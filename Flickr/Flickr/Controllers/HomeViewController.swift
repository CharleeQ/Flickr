//
//  HomeViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum DataSourceItem {
        case loading
        case recent(Recent)
    }
    
    // MARK: - Views
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let control = UIRefreshControl()
    
    // MARK: - Global properties
    private var recents = [DataSourceItem]()
    private var totalPages = 1
    private var currentPage = 1
    private let network = NetworkService(accessToken: UserSettings.get().token,
                                         tokenSecret: UserSettings.get().tokenSecret)
    
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
        
        control.beginRefreshing()
        postsTableView.contentOffset = CGPoint(x: -60, y: 0)
        showRecent()
        
        
        // MARK: - Pull to refresh action
        let action = UIAction.init { action in
            self.recents = []
            self.showRecent()
        }
        control.addAction(action, for: .valueChanged)
    }
    
    private func showRecent(page: Int = 1) {
        network.getRecentPhotos(extras: "date_upload,owner_name,icon_server", page: page) { result in
            switch result {
            case .success(let photos):
                let serialQueue = DispatchQueue(label: "Loading Photos")
                let queueGroup = DispatchGroup()
                self.totalPages = photos.pages
                photos.photo.forEach { item in
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
                    
                    serialQueue.async(group: queueGroup) {
                        let photoStaticURL: String = "https://farm\(item.farm).staticflickr.com/\(item.server)/\(item.id)_\(item.secret)_b.jpg"
                        guard let url = URL(string: photoStaticURL) else { return }
                        guard let data = try? Data(contentsOf: url) else { return }
                        if let image = UIImage(data: data) {
                            photo.image = image
                        }
                    }
                    
                    serialQueue.async(group: queueGroup) {
                        let avaStaticURL: String = "https://farm\(item.iconfarm).staticflickr.com/\(item.iconserver)/buddyicons/\(item.owner).jpg"
                        guard let url = URL(string: avaStaticURL) else { return }
                        guard let data = try? Data(contentsOf: url) else { return }
                        if let image = UIImage(data: data) {
                            photo.profileAvatar = image
                        }
                    }
                    
                    serialQueue.async(group: queueGroup) {
                        self.network.getPhotoInfo(photoID: item.id, secret: nil) { result in
                            switch result {
                            case .success(let info):
                                photo.location = info.owner.location ?? ""
                                photo.fullname = info.owner.realname
                                self.recents.append(.recent(photo))
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
                queueGroup.notify(queue: .main) {
                    self.recents.append(.loading)
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
        switch recents[indexPath.row] {
        case .loading:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "spinnerCell", for: indexPath) as? SpinnerTableViewCell else { return UITableViewCell() }
            return cell
        case .recent(let recent):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
            cell.setup(datas: recent)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch recents[indexPath.row] {
        case .loading:
            return
        case .recent(_/* let recent */):
            // let item = recent
            let detailVC = PostViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch recents[indexPath.row] {
        case .loading:
            if currentPage != totalPages {
                let queueGroup = DispatchGroup()
                let serialQueue = DispatchQueue(label: "Show images")
                serialQueue.async(group: queueGroup) {
                    self.showRecent(page: self.currentPage)
                    self.currentPage += 1
                }
                
                queueGroup.notify(queue: .main) {
                    self.recents.remove(at: indexPath.row)
                    self.postsTableView.reloadData()
                }
            }
        case .recent(_):
            return
        }
    }
}
