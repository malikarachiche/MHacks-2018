//
//  ViewController.swift
//  MHacks StockX
//
//  Created by Malik Arachiche on 10/12/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
var product: [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.getTopProduct(completion: { (response) in
           print(response!)
                self.product = response!
            
        }, category: "sneakers")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func sneakerBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "hiSegue", sender: self)
    }
    
    @IBAction func streetwearBtnPressed(_ sender: Any) {
    }
    @IBAction func watchesBtnPressed(_ sender: Any) {
    }
    
}

