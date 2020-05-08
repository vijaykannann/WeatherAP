//
//  WeatherBaseViewController.swift
//  WeatherApp
//
//  Created by VJ's iMAC on 05/05/20.
//  Copyright © 2020 Deuglo. All rights reserved.
//


import UIKit

class WeatherBaseViewController: UIViewController {
    
    var loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var loaderView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        loaderView.addSubview(loader)
        self.setupSubviews()
        self.loadTableViewCell()
        
        
    }
    
    func setupSubviews(){}
    func loadTableViewCell(){}
    func loadCollectionviewCell(){}
    
    func showLoader(){
        self.view.endEditing(true)
        self.loaderView.frame = UIScreen.main.bounds
        loader.center         = loaderView.center
        loader.startAnimating()
        self.navigationController?.view.addSubview(loaderView)
    }
    func hideLoader(){
        self.loader.stopAnimating()
        self.loaderView.removeFromSuperview()
    }
}
