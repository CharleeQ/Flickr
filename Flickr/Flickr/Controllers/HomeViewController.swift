//
//  HomeViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flickr"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        return cell
    }
    
    
}
