//
//  UserTBCellModel.swift
//  MHacks StockX
//
//  Created by Sehajbir Randhawa on 10/14/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import Foundation

class UserTBCellModel{
    var name: String?
    var uid: String?
    var imageUrl: String?
    var amount: String?
    
    init( name: String, uid: String, imageUrl: String, amount: String) {
        self.name = name
        self.uid  = uid
        self.imageUrl = imageUrl
        self.amount = amount
    }
    
}
