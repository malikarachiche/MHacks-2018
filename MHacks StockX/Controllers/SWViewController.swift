//
//  SWViewController.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/14/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit
import FirebaseAuth

class SWViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var array : [UserTBCellModel] = []

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var bidsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bidsTableView.delegate = self
        bidsTableView.dataSource = self
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        DataService.instance.getMyBids { (arr) in
            self.array = arr
            self.bidsTableView.reloadData()
        }
        
        id.text = Auth.auth().currentUser?.email
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Bids"
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserBidsTableViewCell", for: indexPath) as! UserBidsTableViewCell
        cell.userBid = array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 2, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
         headerLabel.textColor = #colorLiteral(red: 0.8110684752, green: 0.8882920146, blue: 0.9173828959, alpha: 1)
            headerLabel.text = "My Bids"
        
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
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
