//
//  ViewController.swift
//  MHacks StockX
//
//  Created by Malik Arachiche on 10/12/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var whichProd = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func sneakerBtnPressed(_ sender: Any) {
        self.whichProd = "sneakers"
        self.performSegue(withIdentifier: "hiSegue", sender: self)
    }
    
    @IBAction func streetwearBtnPressed(_ sender: Any) {
        self.whichProd = "streetwear"
         self.performSegue(withIdentifier: "hiSegue", sender: self)
    }
    @IBAction func watchesBtnPressed(_ sender: Any) {
         self.whichProd = "watches"
         self.performSegue(withIdentifier: "hiSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CategoryVC
        if(segue.identifier == "hiSegue"){
            vc.whichProd = self.whichProd
        }
    }
}

