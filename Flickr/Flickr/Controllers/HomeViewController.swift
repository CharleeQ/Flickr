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
    //Filters
    @IBOutlet weak var favesFilter: FilterButton!
    @IBOutlet weak var viewsFilter: FilterButton!
    @IBOutlet weak var commentsFilter: FilterButton!
    @IBOutlet weak var interestingFilter: FilterButton!
    
    // MARK: - Global properties
    private var recents = [DataSourceItem]()
    private var totalPages = 1
    private var perPage = 20
    private var currentPage = 1
    private let network = NetworkService(accessToken: UserSettings.get().token,
                                         tokenSecret: UserSettings.get().tokenSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Configuration VC
        postsTableView.refreshControl = control
        
        
        // MARK: - Config filter events
        filterButtonChanged(sender: favesFilter)
        
        
        // MARK: - Pull to refresh action
        let refreshAction = UIAction.init { action in
            self.refresh()
        }
        control.addAction(refreshAction, for: .valueChanged)
        
        
        // MARK: - Get recent photos on the TableView
        refresh()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        filterButtonChanged(sender: sender)
        refresh()
        postsTableView.contentOffset = CGPoint(x: 0, y: -60)
        // coordinate Y, because tableview with X move right (but need bottom)
    }
    
    private func filterButtonChanged(sender: UIButton) {
        favesFilter.alpha = sender == favesFilter ? 1 : 0.5
        viewsFilter.alpha = sender == viewsFilter ? 1 : 0.5
        commentsFilter.alpha = sender == commentsFilter ? 1 : 0.5
        interestingFilter.alpha = sender == interestingFilter ? 1 : 0.5
        
        switch sender {
        case favesFilter: perPage = 15
        case viewsFilter: perPage = 50
        case commentsFilter: perPage = 100
        case interestingFilter: perPage = 200
        default: return
        }
    }
    
    
    private func refresh() {
        recents = []
        currentPage = 1
        if !control.isRefreshing {
            control.beginRefreshing()
            postsTableView.contentOffset = CGPoint(x: -60, y: 0)
        }
        self.showRecent() {
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
        network.getRecentPhotos(extras: "date_upload,owner_name,icon_server", perPage: perPage, page: currentPage) { result in
            switch result {
            case .success(let photos):
                let queueGroup = DispatchGroup()
                self.totalPages = photos.pages
                photos.photo.forEach { item in
                    queueGroup.enter()
                    self.network.getPhotoInfo(photoID: item.id, secret: nil) { result in
                        switch result {
                        case .success(let info):
                            let post = Recent(profileAvatarLink: item.profileImageLink,
                                              username: item.ownername,
                                              fullname: info.owner.realname,
                                              location: info.owner.location ?? "",
                                              link: item.link,
                                              description: item.title,
                                              dateUpload: item.date)
                            self.recents.append(.recent(post))
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
            guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVCID") else { return }
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
