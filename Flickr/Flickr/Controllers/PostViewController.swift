//
//  PostViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 15.09.2021.
//

import UIKit

class PostViewController: UIViewController {
    
    enum DataSourceItem: Equatable {
        case post(Post)
        case comment(CommentPhoto)
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var postDetailTableView: UITableView!
    
    var itemID: String?
    var details = [DataSourceItem]()
    private let network = NetworkService(accessToken: UserSettings.get().token,
                                         tokenSecret: UserSettings.get().tokenSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postDetailTableView.dataSource = self
        postDetailTableView.delegate = self
        
        showPost()
        showComments()
    }
    
    private func showPost() {
        guard let id = itemID else { return }
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
        network.getPhotoInfo(photoID: id, secret: nil) { result in
            switch result {
            case .success(let photo):
                self.details.append(.post(.init(
                    link: photo.link,
                    date: photo.dateuploaded,
                    title: photo.title.content,
                    description: photo.description.content,
                    isFavorite: photo.isFave
                )))
                self.postDetailTableView.reloadData()
                self.spinner.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showComments() {
        guard let id = itemID else { return }
        network.getCommentsList(photoID: id) { result in
            switch result {
            case .success(let comments):
                comments.forEach { comment in
                    self.details.append(.comment(.init(
                        linkToAvatar: comment.profileImageLink,
                        nickname: comment.authorname,
                        content: comment.content,
                        dateCommented: comment.datecreate
                    )))
                }
                self.postDetailTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addFave() {
        guard let faveID = itemID else { return }
        network.addFavorite(photoID: faveID) { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func removeFave() {
        guard let faveID = itemID else { return }
        network.removeFavorite(photoID: faveID) { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            removeFave()
        } else {
            addFave()
        }
        sender.isSelected = !sender.isSelected
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch details[indexPath.row] {
        case .post(let post):
            guard let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "postDetailCell", for: indexPath) as? PostDetailTableViewCell else { return UITableViewCell() }
            cell.config(item: post)
            
            return cell
        case .comment(let comment):
            guard let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            cell.config(item: comment)
            
            return cell
        }
    }
    
}
