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

class AuctionVC: UIViewController {

    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var initialPriceLabel: UILabel!
    
    
    @IBOutlet weak var progressBar: CircularProgressBar!
    
    @IBOutlet weak var currentBidLabel: UILabel!
    
    @IBOutlet weak var bidTextField: UITextField!
    
    var firstAppearance: Date?
    

    
   let DB_BASE = Database.database().reference()
    
    var product: Product!
    
    var fdiff = 0.0
    
    var maxProdAmount = "0.0"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let uuid = product.uuid else {
            print("vfvgdf")
            return
        }
        
        DB_BASE.child("Products").child(uuid).child("HighestBid").observe(.value) { (snapshot) in
        
        
        guard let time = snapshot.childSnapshot(forPath: "Time").value as? String else{
            return
        }
            
        
        
        print(time)
        let myFloat = (time as NSString).doubleValue
        let diff = Date().timeIntervalSince1970 - myFloat
        print(diff)
        self.fdiff = 120 - diff
            
        
        //print(self.fdiff)
        if(self.fdiff > 0 && self.fdiff <= 120){
            self.progressBar.aniDuration = Int(self.fdiff)
        }
        //print(self.progressBar.aniDuration)
        
        
        self.progressBar.labelSize = 60
        self.progressBar.safePercent = Int(self.fdiff)
        self.progressBar.setProgress(to: 1, withAnimation: true)
        
        
    }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDescriptionLabel.text = product.description!
        initialPriceLabel.text = "The starting price is $\(product.currentBid!)"
        guard let uuid = product.uuid else {
            print("vfvgdf")
            return
        }
        DB_BASE.child("Products").child(uuid).child("HighestBid").observe(.value) { (snapshot) in
            
            
            guard let amount = snapshot.childSnapshot(forPath: "Amount").value as? Double else{
                return
            }
            if(amount == 0.0){
                self.currentBidLabel.text = ""
            } else {
                self.currentBidLabel.text = "$\(amount)"
            }
        }
        self.currentBidLabel.text = ""
        downloadImage(from: URL(string: product.image!)!)
 
        // Do any additional setup after loading the .
    }
    
   
    
    @IBAction func bidNow(_ sender: Any) {
        var x = bidTextField.text!
        var y = maxProdAmount
        print("The double val = \(Double(x)!)")
        print("The double val = \(Double(y)!)")
        if(Double(x)! > Double(y)!) {
            DataService.instance.bid(product: product, amount: bidTextField.text!)
            guard let uuid = product.uuid else {
                print("vfvgdf")
                return
            }
            DB_BASE.child("Products").child(uuid).child("HighestBid").observe(.value) { (snapshot) in
                
                
                guard let time = snapshot.childSnapshot(forPath: "Time").value as? String else{
                    return
                }
                
                self.currentBidLabel.text = "Current bid : $\(self.bidTextField.text!)"
                
                print(time)
                let myFloat = (time as NSString).doubleValue
                let diff = Date().timeIntervalSince1970 - myFloat
                
                self.fdiff = 120 - diff
                //print(self.fdiff)
                if(self.fdiff > 0 && self.fdiff<=120){
                    self.progressBar.aniDuration = Int(self.fdiff)
                }
                //print(self.progressBar.aniDuration)
                
                
                self.progressBar.labelSize = 60
                self.progressBar.safePercent = Int(self.fdiff)
                self.progressBar.setProgress(to: 1, withAnimation: true)
                
                
            }
        } else {
            alertcontrollerDisplay(message: "Enter an amount greater than the max bid")
        }
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    func alertcontrollerDisplay(message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func dismissController(_ sender: Any) {
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
