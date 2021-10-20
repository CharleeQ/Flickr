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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let imagePicker = ImagePickerService()
    
    private var gallery = [DataSourceItem]()
    private let network = NetworkService(accessToken: UserSettings.get().token,
                                         tokenSecret: UserSettings.get().tokenSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Config default values
        gallery.append(.newItem)
        
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
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
        let queueGroup = DispatchGroup()
        queueGroup.enter()
        network.uploadPhoto(filename: "photo", image: image, title: "test", description: "test", tags: "test") { result in
            switch result {
            case .success(_):
                queueGroup.leave()
            case .failure(let error):
                print(error)
            }
        }
        queueGroup.notify(queue: .main) {
            self.refresh()
            self.spinner.stopAnimating()
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
            imagePicker.present(presenter: self) { [weak self] image in
                self?.upload(image: image)
            }
        case .photo(_):
            return
        }
    }
}

// MARK: - CollectionView Flow
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.size.width/3) - 1
        return CGSize(width: size, height: size)
    }
}
