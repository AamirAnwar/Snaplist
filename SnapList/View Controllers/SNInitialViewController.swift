//
//  SNInitialViewController.swift
//  SnapList
//
//  Created by Aamir  on 08/05/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire

class SNInitialViewController: UIViewController {

    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var addListButton:UIButton!
    @IBOutlet weak var joinListButton:UIButton!
    var loader:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    override func viewDidLoad() {
        super.viewDidLoad()
        addListButton.addSubview(loader)
        loader.frame = CGRect(x: 2*PADDING_8, y: addListButton.frame.size.height/2 - LoaderSize/2, width: LoaderSize, height: LoaderSize)
    }
}



