//
//  CategoryVC.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var productsArr : [Product] = []
    var whichProd: String = "sneakers"
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSpinner()
        DataService.instance.getTopProduct(completion: { (response) in
            print(response!)
            self.productsArr = response!
            
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            self.removeSpinner()
        }, category: "\(whichProd)")
        
        // Do any additional setup after loading the view.
    }
    
    func addSpinner(){
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (UIScreen.main.bounds.width/2) - ((spinner?.frame.width)!/2), y: 150)
        spinner?.style = .whiteLarge
        spinner?.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    }
    
    func removeSpinner(){
        if(spinner != nil){
            spinner?.removeFromSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatVCCollectionCell", for: indexPath) as! CatVCCollectionCell

        cell.product = productsArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
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
