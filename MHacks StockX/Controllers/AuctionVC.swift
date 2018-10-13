//
//  AuctionVC.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit

class AuctionVC: UIViewController {

    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var initialPriceLabel: UILabel!
    
    @IBOutlet weak var currentBidLabel: UILabel!
    
    @IBOutlet weak var bidTextField: UITextField!
    
    var product: Product!
    override func viewDidLoad() {
        super.viewDidLoad()
        productDescriptionLabel.text = product.description!
        initialPriceLabel.text = "The current bid is " + product.currentBid!
        downloadImage(from: URL(string: product.image!)!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bidNow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.productImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
