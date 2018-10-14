
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
    
    
    
    let DB_BASE = Database.database().reference()
    
    var product: Product!
    
    var fdiff = 0.0
    
    var maxProdAmount = "0.0"
    
    override func viewWillAppear(_ animated: Bool) {
        guard let uuid = product.uuid else {
            //print("vfvgdf")
            return
        }
        self.DB_BASE.child("Products").child(uuid).child("Bids").observe(.childAdded) { (snapshot) in

           // self.messageDisplay(message: "A new bid of $\(self.DB_BASE.child("Products").child(uuid).child("HighestBid").value(forKey: "Amount") as! String) has been set")


            guard let time = snapshot.childSnapshot(forPath: "Time").value as? String else{
                return
            }

            guard let amount = snapshot.childSnapshot(forPath: "Amount").value as? String else{
                return
            }
            
            

            if(amount != nil || amount != "") {
                self.currentBidLabel.text = "\(amount)"
                self.messageDisplay(message: "A new bid of $\(amount) has been set")
            } else {
                self.currentBidLabel.text = "0"
            }

            let myFloat = (time as NSString).doubleValue
            let diff = Date().timeIntervalSince1970 - myFloat
            //print(diff)
            self.fdiff = 120 - diff



            if(self.fdiff > 1 && self.fdiff <= 120){
                self.progressBar.startProgress(to: 0, duration: 0, completion: {
                    self.progressBar.startProgress(to: 100, duration: self.fdiff, completion: {
                        self.messageDisplay(message: "The auction is now over")
                         self.currentBidLabel.text = "0"
                    })
                })

            }
            else{
                self.DB_BASE.child("Products").child(uuid).removeValue()

            }





        }
        
       
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let uuid = product.uuid else {
           // print("vfvgdf")
            return
        }
        
    
        

        DB_BASE.child("Products").child(uuid).child("HighestBid").observeSingleEvent(of: .value) { (snapshot) in

            guard let time = snapshot.childSnapshot(forPath: "Time").value as? String else{
                return
            }

            guard let amount = snapshot.childSnapshot(forPath: "Amount").value as? String else{
                return
            }

            if(amount != nil || amount != "") {
                self.currentBidLabel.text = "\(amount)"
            } else {
                self.currentBidLabel.text = "0"
            }

            let myFloat = (time as NSString).doubleValue
            let diff = Date().timeIntervalSince1970 - myFloat
            //print(diff)
            self.fdiff = 120 - diff
            
            

            if(self.fdiff > 1 && self.fdiff <= 120){
               // self.progressBar.startProgress(to: 0, duration: 0)
                self.progressBar.startProgress(to: 100, duration: self.fdiff)

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
        
        guard let uuid = product.uuid else {
            return
        }
        //print(currentBidLabel.text!)
        DataService.instance.bid(product: product, amount: bidTextField.text!) { (success, tempTime) in
            if(success) {
               // self.messageDisplay(message: "A new bid of $\(self.bidTextField.text!) has been set")
                self.currentBidLabel.text = self.bidTextField.text!

                
                print("You on the right track")

                let myFloat = (tempTime as NSString).doubleValue
                let diff = Date().timeIntervalSince1970 - myFloat
                
                self.fdiff = 120 - diff
                if(self.fdiff > 1 && self.fdiff<=120){
                    self.progressBar.startProgress(to: 0, duration: 0, completion: {
                        self.progressBar.startProgress(to: 100, duration: self.fdiff, completion: {
                            self.messageDisplay(message: "The auction is now over")
                            self.currentBidLabel.text = "0"
                        })
                    })
                    

                } else{
                    self.DB_BASE.child("Products").child(uuid).removeValue()
                }
            } else
            {
                //print("False, alert msg")
                self.alertcontrollerDisplay(message: "Error. Enter a higher bid.")
            }
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
        }
        alertController.addAction(okAction)
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
