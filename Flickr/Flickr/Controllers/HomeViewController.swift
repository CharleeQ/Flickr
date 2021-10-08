//
//  HomeViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum DataSourceItem: Equatable {
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
        refresh()
        
        
        // MARK: - Pull to refresh action
        let action = UIAction.init { action in
            self.refresh()
        }
        control.addAction(action, for: .valueChanged)
    }
    
    private func refresh() {
        recents = []
        currentPage = 1
        if !control.isRefreshing {
            control.beginRefreshing()
            postsTableView.contentOffset = CGPoint(x: -60, y: 0)
        }
        self.showRecent {
            self.control.endRefreshing()
        }
    }
    
    private func nextPage() {
        if currentPage != totalPages {
            self.currentPage += 1
        }
        self.showRecent(completion: {})
    }
    
    private func showRecent(completion: @escaping () -> ()) {
        if recents.last == DataSourceItem.loading { recents.removeLast() }
        network.getRecentPhotos(extras: "date_upload,owner_name,icon_server", page: currentPage) { result in
            switch result {
            case .success(let photos):
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
                    
                    DispatchQueue(label: "Serial").async(group: queueGroup) {
                        let photoStaticURL: String = "https://farm\(item.farm).staticflickr.com/\(item.server)/\(item.id)_\(item.secret)_b.jpg"
                        guard let url = URL(string: photoStaticURL) else { return }
                        guard let data = try? Data(contentsOf: url) else { return }
                        if let image = UIImage(data: data) {
                            photo.image = image
                        }
                        let avaStaticURL: String = "https://farm\(item.iconfarm).staticflickr.com/\(item.iconserver)/buddyicons/\(item.owner).jpg"
                        guard let url = URL(string: avaStaticURL) else { return }
                        guard let data = try? Data(contentsOf: url) else { return }
                        if let image = UIImage(data: data) {
                            photo.profileAvatar = image
                        }
                    }
                    
                    queueGroup.enter()
                    self.network.getPhotoInfo(photoID: item.id, secret: nil) { result in
                        switch result {
                        case .success(let info):
                            photo.location = info.owner.location ?? ""
                            photo.fullname = info.owner.realname
                            self.recents.append(.recent(photo))
                        case .failure(let error):
                            print(error)
                        }
                        queueGroup.leave()
                    }
                }
                queueGroup.notify(queue: .main) {
                    self.recents.append(.loading)
                    self.postsTableView.reloadData()
                    completion()
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
        guard indexPath.row != recents.count else { return UITableViewCell() }
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
            nextPage()
        case .recent(_):
            return
        }
    }
}
