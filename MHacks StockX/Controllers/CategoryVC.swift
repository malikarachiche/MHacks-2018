//
//  CategoryVC.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit


class CategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var productsArr : [Product] = []
    var original: [Product] = []
    var whichProd: String = "sneakers"
    var spinner: UIActivityIndicatorView?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Selectbtn: UIButton!
    
  
    var dataSrc = ["Jordan", "Saucony", "Diadora", "Under Armour", "Off-White", "Fear of God", "Puma", "Nike", "Reebok", "Louis Vuitton", "Revenge X Storm", "Asics", "Vans", "adidas", "A Bathing Ape", "New Balance", "Converse" ]
    

    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var TFHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectBrandHeightConstraint: NSLayoutConstraint!
    var selectedProduct: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        menuButton.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        
        
        TFHeightConstraint.constant = 0
        tableViewConstraint.constant = 0
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(goBtnPressed), for: .editingChanged)
        
        
        addSpinner()
        DataService.instance.getTopProduct(completion: { (response) in
            
            self.productsArr = response!
            self.original = response!
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            self.removeSpinner()
        }, category: "")
        
        
    }
    
    
    
    @objc func goBtnPressed() {
        addSpinner()
        DataService.instance.getSearchResult(completion: { (prod) in
            if(prod != nil){
            if(self.searchTF.text! == "") {
                
                self.productsArr = self.original
                self.collectionView.reloadData()
                //self.removeSpinner()
                
            } else {
            
                self.productsArr = prod!
                self.collectionView.reloadData()
                
                
            }
            }
            
           
        }, searchQueryy: searchTF.text!)
        self.removeSpinner()
    }
    @IBAction func selectBtnPressed(_ sender: Any) {
        if( self.tableViewConstraint.constant == 0){
            animate(toggle: true)
        }
        else{
            animate(toggle: false)
        }
    }
    
   
    
    func animate(toggle: Bool){
        if(toggle){
            UIView.animate(withDuration: 0.3) {
                self.tableViewConstraint.constant = 138
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.tableViewConstraint.constant = 0
            }
        }
    }
    @IBAction func searchBtnPressed(_ sender: Any) {
        if(selectBrandHeightConstraint.constant == 45){
            selectBrandHeightConstraint.constant = 0
            selectButton.isHidden = true
            TFHeightConstraint.constant = 40
        }else{
            selectBrandHeightConstraint.constant = 45
            selectButton.isHidden = false
            TFHeightConstraint.constant = 0
        }
    }
    
    func addSpinner(){
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (UIScreen.main.bounds.width/2) - ((spinner?.frame.width)!/2), y: 150)
        spinner?.style = .whiteLarge
        spinner?.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = productsArr[indexPath.row]
        self.performSegue(withIdentifier: "auctionSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSrc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath)
        cell.textLabel?.text = dataSrc[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Selectbtn.setTitle("\(dataSrc[indexPath.row])", for: .normal)
        animate(toggle: false)
        self.addSpinner()
        DataService.instance.getTopProduct(completion: { (response) in
            
            self.productsArr = response!
            
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            self.removeSpinner()
            self.collectionView.reloadData()
        }, category: dataSrc[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AuctionVC
        vc.product = selectedProduct
    }

}
