//
//  HomeViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    let control = UIRefreshControl()
    var recents = [Recent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Configuration VC
        // refreshing
        postsTableView.refreshControl = control
        // logo image in navbar
        let logo = UIImage(named: "logoSmall.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        
        // MARK: - Get recent photos on TableView
        let network = NetworkService(accessToken: UserSettings.get().token,
                                     tokenSecret: UserSettings.get().tokenSecret)
        control.beginRefreshing()
        postsTableView.contentOffset = CGPoint(x: -60, y: 0)
        getRecent(network: network)
        
        
        // MARK: - Pull to refresh action
        let action = UIAction.init { action in
            self.getRecent(network: network)
        }
        control.addAction(action, for: .valueChanged)
    }
    
    private func getRecent(network: NetworkService) {
        self.recents = []
        network.getRecentPhotos(extras: "date_upload,owner_name,icon_server") { result in
            switch result {
            case .success(let photos):
                photos.forEach { item in
                    var photo = Recent()
                    photo.username = item.ownername
                    photo.description = item.title
                    
                    if let time = Double(item.dateupload) {
                        let date = Date(timeIntervalSince1970: time)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY MMMM dd, hh:mm:ss"
                        dateFormatter.timeZone = .current
                        photo.dateUpload = dateFormatter.string(from: date)
                    }
                    
                    let photoStaticURL: String = "https://farm\(item.farm).staticflickr.com/\(item.server)/\(item.id)_\(item.secret)_b.jpg"
                    guard let url = URL(string: photoStaticURL) else { return }
                    guard let data = try? Data(contentsOf: url) else { return }
                    if let image = UIImage(data: data) {
                        photo.image = image
                    }
                    
                    DispatchQueue.global().async {
                        let avaStaticURL: String = "https://farm\(item.iconfarm).staticflickr.com/\(item.iconserver)/buddyicons/\(item.owner).jpg"
                        guard let url = URL(string: avaStaticURL) else { return }
                        guard let data = try? Data(contentsOf: url) else { return }
                        if let image = UIImage(data: data) {
                            photo.profileAvatar = image
                        }
                    }
                    
                    network.getPhotoInfo(photoID: item.id, secret: nil) { result in
                        switch result {
                        case .success(let info):
                            photo.location = info.owner.location ?? ""
                            photo.fullname = info.owner.realname
                            
                            self.recents.append(photo)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
                    self.control.endRefreshing()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        cell.setup(data: recents[indexPath.row])
        
        return cell
    }
}
