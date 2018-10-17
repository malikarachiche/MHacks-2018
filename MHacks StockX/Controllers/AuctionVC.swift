
//
//  AuctionVC.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftyUUID
import Firebase
import UICircularProgressRing

class AuctionVC: UIViewController {
    
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var initialPriceLabel: UILabel!
    
    @IBOutlet weak var progressBar: UICircularProgressRing!
    
    @IBOutlet weak var currentBidLabel: UILabel!
    
    @IBOutlet weak var bidTextField: UITextField!
    
    var firstAppearance: Date?
    
    
    @IBOutlet weak var bidBtn: RoundedButton!
    
    let DB_BASE = Database.database().reference()
    
    var product: Product!
    
    var fdiff = 0.0
    
    var maxProdAmount = "0.0"
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        print("\n\nIn will appear\n\n")
//        guard let uuid = product.uuid else {
//            return
//        }
//        self.DB_BASE.child("Products").child(uuid).child("HigestBid").observeSingleEvent(of: .value) { (snapshot) in
//            
//            
//            guard let time = snapshot.childSnapshot(forPath: "Time").value as? String else{
//                return
//            }
//            
//            guard let amount = snapshot.childSnapshot(forPath: "Amount").value as? String else{
//                return
//            }
//            
//            
//            
//            if(amount != nil || amount != "") {
//                self.currentBidLabel.text = "\(amount)"
//                
//            } else {
//                self.currentBidLabel.text = "0"
//            }
//            
//            let myFloat = (time as NSString).doubleValue
//            let diff = Date().timeIntervalSince1970 - myFloat
//            self.fdiff = 60 - diff
//            
//            
//            
//            if(self.fdiff > 1 && self.fdiff <= 60){
//                
//                
//                self.progressBar.startProgress(to: 0, duration: 1, completion: {
//                    
//                    
//                    self.progressBar.startProgress(to: 100, duration: self.fdiff, completion: {
//                        
//                        
//                        self.dismiss(animated: true, completion: nil)
//                        self.messageDisplay(message: "The auction is now over")
//                        self.DB_BASE.child("Products").child(uuid).removeValue()
//                        
//                        
//                    })
//                })
//                
//            }
//            else{
//                self.DB_BASE.child("Products").child(uuid).removeValue()
//                
//            }
//            
//            
//            
//            
//            
//        }
//        
//        
//        
//        
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let uuid = product.uuid else {
            return
        }
        
        
        
        self.DB_BASE.child("Products").child(product.uuid!).child("Bids").observe(.childAdded)  { (snapshot) in
            
            
            guard let time = snapshot.childSnapshot(forPath: "Time").value as? String else{
                return
            }
            
            guard let amount = snapshot.childSnapshot(forPath: "Amount").value as? String else{
                return
            }
            
            
            
            
            if(amount != nil || amount != "") {
                self.currentBidLabel.text = "\(amount)"
                self.messageDisplayNoAction(message: "A new bid of $\(amount) has been set")
                
            } else {
                self.currentBidLabel.text = "0"
            }
            
            
            let myFloat = (time as NSString).doubleValue
            let diff = Date().timeIntervalSince1970 - myFloat
            self.fdiff = 60 - diff
            
            
            
            if(self.fdiff > 1 && self.fdiff <= 60){
                
                
                self.progressBar.startProgress(to: 0, duration: 1, completion: {
                    
                    
                    self.progressBar.startProgress(to: 100, duration: self.fdiff, completion: {
                        
                        
                        self.dismiss(animated: true, completion: nil)
                        self.messageDisplay(message: "The auction is now over")
                        self.DB_BASE.child("Products").child(uuid).removeValue()
                        
                        
                    })
                })
                
                
                
                
            }
            else{
                self.DB_BASE.child("Products").child(uuid).removeValue()
                
            }
            
            
            
            
            
        }
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        productDescriptionLabel.text = product.description!
        initialPriceLabel.text = "The starting price is $\(product.currentBid!)"
        currentBidLabel.text = "0"
        self.downloadImage(from: URL(string: self.product.image!)!)
        
        
        
        
        DataService.instance.getHighestBidAmount(completion: { (amountString) in
            self.currentBidLabel.text = "$\(amountString)"
            
        }, product: product)
        
        
    }
    
    
    
    
    @IBAction func bidNow(_ sender: Any) {
        
        DataService.instance.bid(product: product, amount: bidTextField.text!) { (success, tempTime) in
            
        }
        
    }
    
    func alertcontrollerDisplay(message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func messageDisplay(message: String){
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func messageDisplayNoAction(message: String){
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handler(alert: UIAlertAction!){
        self.dismiss(animated: true, completion: nil)
    }
    
    func specMessage(message: String){
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (aa) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadImage(from url: URL) {
        //print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            DispatchQueue.main.async() {
                self.productImageView.image = UIImage(data: data)
            }
            
        }
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    
}
