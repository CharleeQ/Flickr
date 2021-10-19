//
//  GalleryViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    enum DataSourceItem: Equatable {
        case newItem
        case photo(UsersPhoto)
    }
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
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
}

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
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/3) - 1,
                      height: (view.frame.size.width/3) - 1)
    }
}
