//
//  HomeViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

struct Recent {
    var profileAvatar: UIImage = UIImage(systemName: "person.fill")!
    var username: String = "Unknown"
    var fullname: String = "Unknown user"
    var location: String = "No location"
    var image: UIImage = UIImage(systemName: "photo")!
    var description: String = ""
    var dateUpload: String = "2004 September 19 00:01:23"
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var postsTableView: UITableView!
    var recents = [Recent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // logo image in navbar
        let logo = UIImage(named: "logoSmall.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        let network = NetworkService(accessToken: UserSettings.get().token,
                                     tokenSecret: UserSettings.get().tokenSecret)
        
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
                    
                    let avaStaticURL: String = "https://farm\(item.iconfarm).staticflickr.com/\(item.iconserver)/buddyicons/\(item.owner).jpg"
                    guard let url = URL(string: avaStaticURL) else { return }
                    guard let data = try? Data(contentsOf: url) else { return }
                    if let image = UIImage(data: data) {
                        photo.profileAvatar = image
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
        cell.datas = recents[indexPath.row]
        
        return cell
    }
}
