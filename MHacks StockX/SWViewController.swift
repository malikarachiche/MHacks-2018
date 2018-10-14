//
//  SWViewController.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/14/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit

class SWViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        // Do any additional setup after loading the view.
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
