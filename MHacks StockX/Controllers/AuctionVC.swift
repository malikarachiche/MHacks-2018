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
        initialPriceLabel.text = product.currentBid!
        
        downloadImage(from: URL(string: product.image!)!)
        
//        guard let uuid = product.uuid else {
//            print("vfvgdf")
//            return
//        }
//
//        DB_BASE.child("Products").child(uuid).child("HighestBid").observe(.value) { (snapshot) in
//
//
//            guard let time = snapshot.childSnapshot(forPath: "Time").value as? String else{
//                return
//            }
//
//           print(time)
//            let myFloat = (time as NSString).doubleValue
//           let diff = Date().timeIntervalSince1970 - myFloat
//
//            self.fdiff = 600 - diff
//            //print(self.fdiff)
//            if(self.fdiff>0){
//            self.progressBar.aniDuration = Int(self.fdiff)
//            }
//            //print(self.progressBar.aniDuration)
//
//
//            self.progressBar.labelSize = 60
//            self.progressBar.safePercent = Int(self.fdiff)
//            self.progressBar.setProgress(to: 1, withAnimation: true)
//
//
//        }
 
        // Do any additional setup after loading the .
    }
    
   
    
    @IBAction func bidNow(_ sender: Any) {
        DataService.instance.bid(product: product, amount: bidTextField.text!)
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
        //self.dismiss(animated: true, completion: nil)
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
