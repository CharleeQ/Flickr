//
//  GalleryViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit
import Photos
import PhotosUI

class GalleryViewController: UIViewController {
    
    enum DataSourceItem: Equatable {
        case newItem
        case photo(UsersPhoto)
    }
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    let imagePicker = UIImagePickerController()
    var photoPicker: PHPickerViewController!
    
    private var gallery = [DataSourceItem]()
    private let network = NetworkService(accessToken: UserSettings.get().token,
                                         tokenSecret: UserSettings.get().tokenSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Config default values
        gallery.append(.newItem)
        
        if #available(iOS 14, *) {
            // MARK: - Config PHPickerViewController
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .images
            photoPicker = PHPickerViewController(configuration: config)
            photoPicker.delegate = self
        } else {
            // MARK: - Config UIImagePickerController
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
        }
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
        showGallery()
    }
    
    private func showGallery() {
        network.getPhotos(userID: UserSettings.get().nsid.removingPercentEncoding!, extras: nil) { result in
            switch result {
            case .success(let photos):
                photos.forEach { photo in
                    self.gallery.append(.photo(photo))
                    self.photoCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func refresh() {
        gallery = [.newItem]
        showGallery()
    }
    
    private func upload(image: UIImage) {
        network.uploadPhoto(filename: "photo", image: image, title: "test", description: "test", tags: "test") { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.refresh()
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - CollectionView
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch gallery[indexPath.row] {
        case .newItem:
            return photoCollectionView.dequeueReusableCell(withReuseIdentifier: "uploadPhotoCell", for: indexPath)
        case .photo(let photo):
            guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.config(data: photo)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch gallery[indexPath.row] {
        case .newItem:
            if #available(iOS 14, *) {
                self.present(photoPicker, animated: true, completion: nil)
            } else {
                print("image picker present")
                self.present(imagePicker, animated: true, completion: nil)
            }
        case .photo(_):
            return
        }
    }
}

// MARK: - CollectionView Flow
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/3) - 1,
                      height: (view.frame.size.width/3) - 1)
    }
}

// MARK: - UIImagePicker
extension GalleryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        upload(image: image)
    }
}

// MARK: - PHPickerView
extension GalleryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                self.upload(image: image)
            }
        }
    }
}
