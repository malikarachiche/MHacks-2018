//
//  DataService.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftyUUID
import Firebase

let DB_BASE = Database.database().reference()

class DataService{

    static let instance = DataService()
    var REF_BASE = DB_BASE
    
    var base_urlString = "https://gateway.stockx.com/public"
   
    
    
    
    func getTopProduct(completion: @escaping ([Product]?)->(), category: String){
        
        var productArray: [Product] = []
        
        base_urlString = base_urlString + "/v1/browse?limit=500"
        var base_url = URL(string: base_urlString)
        
        Alamofire.request(base_url!, method: .get, parameters: ["limit":"500"], headers: ["x-api-key":"B1sR9t386d6UVO6aI7KRf91gLaUywqEK1TLBGsXv"]).responseJSON { (response) in
    
            if(response.result.error == nil){
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
                    
                    if let array = json["Products"].array{
                        
                        for item in array{
                            if(item["brand"].stringValue == category || category == ""){
                                
                           var img = item["media"]["smallImageUrl"].stringValue
                                if(img == ""){
                                    img = item["media"]["thumbUrl"].stringValue
                                }
                                let description = item["shoe"].stringValue
                                let uid = item["uuid"].stringValue
                                
                               var currentB = item["market"]["lowestAsk"].stringValue
                                
                                let product = Product(description: description, currentBid: currentB, image: img, uuid: uid)
                                productArray.append(product)
                        }
                        //    print(productArray)
                        completion(productArray)
                        
                    }
                    }
                }catch{
                   
                }
            }else{
                 completion(nil)
            }
        }
        
    }

    func bid(product : Product, amount : String, completion: @escaping (Bool, String)->()) {
        let ID = SwiftyUUID.UUID()
        let idString = ID.CanonicalString()
        print("biddd")
        DB_BASE.child("Products").child(product.uuid!).child("HighestBid").observeSingleEvent(of: .value) { (snapshot) in
            print("in biddd")
            
            //var amountRN2 = product.currentBid
            guard let amountRN = snapshot.childSnapshot(forPath: "Amount").value as? String else{
                
               print(amount)
                print(product.currentBid!)
                if(Double(amount)! > Double(product.currentBid!)!){
                    print("true 1")
                    let time = Date().timeIntervalSince1970
                    let values = ["Puid" : (Auth.auth().currentUser?.uid)!, "Amount" : amount, "Time" : String(time)] as [String : String]

                    self.REF_BASE.child("Products").child(product.uuid!).child("HighestBid").setValue(values)
                    self.REF_BASE.child("Products").child(product.uuid!).child("Bids").child(idString).setValue(values)
                    print("more")
                    completion(true, String(time))
                    
                }else{
                    print("false 1")
                    completion(false,"")
                    
                }
                return
              
            }
            
            
            
            
            
            if Double(amount)! < Double(amountRN)! {
                print("false 2")
                completion(false, "")
                
                return
            }
            
            let time = Date().timeIntervalSince1970
            let values = ["Puid" : (Auth.auth().currentUser?.uid)!, "Amount" : amount, "Time" : String(time)] as [String : String]
            
            self.REF_BASE.child("Products").child(product.uuid!).child("HighestBid").setValue(values)
            self.REF_BASE.child("Products").child(product.uuid!).child("Bids").child(idString).setValue(values)
            print("true 2")
            completion(true, String(time))
            return
            
        }
       
        
    }

    func getHighestBidAmount(completion: @escaping (String)->(), product: Product){
        DB_BASE.child("Products").child(product.uuid!).child("HighestBid").observe(.value) { (snapshot) in
            
            
            guard let amount = snapshot.childSnapshot(forPath: "Amount").value as? Double else{
                return
            }
            if(amount == 0.0){
                completion("0")
                //self.currentBidLabel.text = ""
            } else {
                completion(String(amount))
               
            }
        }
    }

}






