//
//  SNInitialViewController.swift
//  SnapList
//
//  Created by Aamir  on 08/05/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMobileAds

class SNInitialViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var addListButton:UIButton!
    @IBOutlet weak var joinListButton:UIButton!
    var bannerView: GADBannerView!
    var loader:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    override func viewDidLoad() {
        super.viewDidLoad()
        addListButton.addSubview(loader)
        loader.frame = CGRect(x: 2*PADDING_8, y: addListButton.frame.size.height/2 - LoaderSize/2, width: LoaderSize, height: LoaderSize)
        
        // Create a google ad here
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        view.addSubview(bannerView)
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.frame = CGRect(x: 0, y: view.frame.height - bannerView.frame.height, width: bannerView.frame.width, height: bannerView.frame.height)
    }
    
}



