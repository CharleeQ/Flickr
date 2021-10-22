//
//  PostViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 15.09.2021.
//

import UIKit

class PostViewController: UIViewController {
    
    enum DataSourceItem: Equatable {
        case post
        case comment(CommentPhoto)
    }
    
    @IBOutlet weak var postDetailTableView: UITableView!
    
    var item: Recent?
    var details = [DataSourceItem]()
    private let network = NetworkService(accessToken: UserSettings.get().token,
                                         tokenSecret: UserSettings.get().tokenSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postDetailTableView.dataSource = self
        postDetailTableView.delegate = self
        
        details.append(.post)
        
        showComments()
    }
    
    private func showComments() {
        guard let id = item?.id else { return }
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
        guard let fave = item else { return }
        network.addFavorite(photoID: fave.id) { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func removeFave() {
        guard let fave = item else { return }
        network.removeFavorite(photoID: fave.id) { result in
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
        case .post:
            guard let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "postDetailCell", for: indexPath) as? PostDetailTableViewCell, let item = item else { return UITableViewCell() }
            cell.config(item: item)
            
            return cell
        case .comment(let comment):
            guard let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            cell.config(item: comment)
            
            return cell
        }
    }
    
}
