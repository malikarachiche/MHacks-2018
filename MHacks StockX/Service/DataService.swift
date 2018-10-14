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
   
    func getSearchResult(completion: @escaping ([Product]?)->(), searchQueryy: String){
        var productArray: [Product] = []
       var searchQuery =  searchQueryy.replacingOccurrences(of: " ", with: "")
        
        base_urlString = "https://gateway.stockx.com"
        base_urlString = base_urlString + "/stage/v2/search?query=\(searchQuery)"
        var base_url = URL(string: base_urlString)
        
        Alamofire.request(base_url!, method: .get, parameters: ["query":searchQuery], headers: ["x-api-key":"B1sR9t386d6UVO6aI7KRf91gLaUywqEK1TLBGsXv"]).responseJSON { (response) in
            
            if(response.result.error == nil){
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
                    
                    if let array = json["hits"].array{
                        
                        completion(productArray)
                        for item in array{
                            //if(item["brand"].stringValue == category || category == ""){

                                var img = item["media"]["smallImageUrl"].stringValue
                                if(img == ""){
                                    img = item["media"]["thumbUrl"].stringValue
                                    if (img == ""){
                                        continue
                                    }
                                }
                                let description = item["name"].stringValue
                                let uid = item["objectID"].stringValue

                                var currentB = item["lowest_ask"].stringValue
                          

                                let product = Product(description: description, currentBid: currentB, image: img, uuid: uid)
                            print("The query : \(searchQuery)")
                            print("the image : \(product.image!)")
                                productArray.append(product)
                            //}
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
    
    func getMyBids(completion: @escaping ([UserTBCellModel])->()) {
        
        DB_BASE.child("Users").child((Auth.auth().currentUser?.uid)!).observe(.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects  as? [DataSnapshot] else { return }
            print("The shit:")
            print(snapshot)
            var arr : [UserTBCellModel] = []
            for snap in snapshot{
                guard let innerSnapshot = snap.childSnapshot(forPath: "name").value as? String else{ return }
                guard let innerSnapshot2 = snap.childSnapshot(forPath: "amount").value as? String else{ return }
                guard let innerSnapshot3 = snap.childSnapshot(forPath: "uuid").value as? String else{ return }
                guard let innerSnapshot4 = snap.childSnapshot(forPath: "imageUrl").value as? String else{ return }
                let u = UserTBCellModel(name: innerSnapshot, uid: innerSnapshot3, imageUrl: innerSnapshot4, amount: "$\(innerSnapshot2)")
                arr.append(u)
            }
            print(arr)
            completion(arr)
        }
    }

    func bid(product : Product, amount : String, completion: @escaping (Bool, String)->()) {
        let ID = SwiftyUUID.UUID()
        let idString = ID.CanonicalString()

        
        DB_BASE.child("Products").child(product.uuid!).child("HighestBid").observeSingleEvent(of: .value) { (snapshot) in
            
            //var amountRN2 = product.currentBid
            guard let amountRN = snapshot.childSnapshot(forPath: "Amount").value as? String else{
           
               print(amount)
                print(product.currentBid!)
                if(Double(amount)! >= Double(product.currentBid!)!){
                    //print("true 1")
                    let time = Date().timeIntervalSince1970
                    let values = ["Puid" : (Auth.auth().currentUser?.uid)!, "Amount" : amount, "Time" : String(time)] as [String : String]

                    self.REF_BASE.child("Products").child(product.uuid!).child("HighestBid").setValue(values)
                    self.REF_BASE.child("Products").child(product.uuid!).child("Bids").child(idString).setValue(values)
                    
                    let ID = SwiftyUUID.UUID()
                    let idString = ID.CanonicalString()
                    let values2 = ["name" : product.description!, "amount" : amount, "uuid" : product.uuid!, "imageUrl" : product.image!] as [String : String]
                    self.REF_BASE.child("Users").child((Auth.auth().currentUser?.uid)!).child(idString).setValue(values2)

                    completion(true, String(time))
                    
                }else{

                    completion(false,"")
                    
                }
                return
              
            }

            if Double(amount)! <= Double(amountRN)! {

                completion(false, "")
                
                return
            }
            
            let time = Date().timeIntervalSince1970
            let values = ["Puid" : (Auth.auth().currentUser?.uid)!, "Amount" : amount, "Time" : String(time)] as [String : String]
            
            self.REF_BASE.child("Products").child(product.uuid!).child("HighestBid").setValue(values)
            self.REF_BASE.child("Products").child(product.uuid!).child("Bids").child(idString).setValue(values)
            let values2 = ["name" : product.description!, "amount" : amount, "uuid" : product.uuid!, "imageUrl" : product.image!] as [String : String]
            self.REF_BASE.child("Users").child((Auth.auth().currentUser?.uid)!).child(idString).setValue(values2)

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
                
            } else {
                completion(String(amount))
               
            }
        }
    }

}






