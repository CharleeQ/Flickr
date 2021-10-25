//
//  ImagePickerService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.10.2021.
//

import UIKit
import PhotosUI

class ImagePickerService: NSObject {
    typealias Completion = ((UIImage) -> Void)
    
    var completion: Completion?
    func present(presenter: UIViewController, completion: @escaping Completion) {
        if #available(iOS 14, *) {
            // MARK: - Config PHPickerViewController
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .images
            let photoPicker = PHPickerViewController(configuration: config)
            photoPicker.delegate = self
            presenter.present(photoPicker, animated: true, completion: nil)
        } else {
            // MARK: - Config UIImagePickerController
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            presenter.present(imagePicker, animated: true, completion: nil)
        }
        self.completion = completion
    }
}


// MARK: - UIImagePicker
extension ImagePickerService: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        picker.dismiss(animated: true) {
            self.completion?(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - PHPickerView
extension ImagePickerService: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results == [] {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true) {
            results.forEach { result in
                result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                    guard let image = reading as? UIImage, error == nil else { return }
                    self.completion?(image)
                }
            }
        }
    }
}
