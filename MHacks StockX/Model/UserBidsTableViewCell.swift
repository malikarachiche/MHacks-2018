//
//  UserBidsTableViewCell.swift
//  MHacks StockX
//
//  Created by Sehajbir Randhawa on 10/14/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit

class UserBidsTableViewCell: UITableViewCell {

    @IBOutlet weak var productPic: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var userBid : UserTBCellModel! {
        didSet{
            productName.text = userBid.name!
            amountLabel.text = userBid.amount!
            downloadImage(from: URL(string: userBid.imageUrl!)!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func downloadImage(from url: URL) {
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            
            DispatchQueue.main.async() {
                self.productPic.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
