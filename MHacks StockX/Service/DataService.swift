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

//let DB_BASE = Database.database().reference()

class DataService{

    static let instance = DataService()
  //  var REF_BASE = DB_BASE
    
    var base_urlString = "https://gateway.stockx.com/public"
   
    
    
    
    func getTopProduct(completion: @escaping ([Product]?)->(), category: String){
        
        var productArray: [Product] = []
        
        base_urlString = base_urlString + "/v1/browse?limi1=100"
        var base_url = URL(string: base_urlString)
        
        Alamofire.request(base_url!, method: .get, parameters: ["limit":"100"], headers: ["x-api-key":"B1sR9t386d6UVO6aI7KRf91gLaUywqEK1TLBGsXv"]).responseJSON { (response) in
            //print(response)
            if(response.result.error == nil){
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
                    
                    if let array = json["Products"].array{
                        
                        
                        
                        for item in array{
                            if(item["productCategory"].stringValue == category){
                                
                          // let img = item["media"]["imageUrl"].stringValue
                                let description = item["shortDescription"].stringValue
                                let uuid = item["uuid"].stringValue
                                
                                
let product = Product(description: description, currentBid: "", image: "", uuid: uuid)
                                productArray.append(product)

                            
                        }
                            
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
    
//    func getTopProductsCurrBid(completion: @escaping ([Product]?)->(), prodArray: [Product]){
//        for item in prodArray {
//            
//            base_urlString = base_urlString + "/v1/products/" + item.uuid! + "?includes=market"
//            
//            var base_Url = URL(string: base_urlString )
//            
//            Alamofire.request(base_Url, method: .get, parameters: ["id":"\(item.uuid!)"], headers: ["x-api-key":"B1sR9t386d6UVO6aI7KRf91gLaUywqEK1TLBGsXv"]).responseJSON { (response) in
//                
//            }
//            
//            
//            
//            
//        }
//    }
}






