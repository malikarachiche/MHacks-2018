//
//  Product.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import Foundation

class Product{
    var description: String?
    var currentBid: String?
    var image: String?
    var uuid: String?
    
    init( description: String, currentBid: String, image: String, uuid: String) {
        self.description = description
        self.currentBid  = currentBid
        self.image = image
        self.uuid = uuid
    }
    
}
