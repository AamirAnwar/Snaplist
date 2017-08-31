//
//  SNRectButton.swift
//  SnapList
//
//  Created by Aamir  on 26/08/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
let LoaderSize:CGFloat = 20

class SNRectButton: UIButton {
    
    let loader = UIActivityIndicatorView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        loader.hidesWhenStopped = true
        loader.activityIndicatorViewStyle = .white
        self.addSubview(loader)
    }
    
    public func showLoader() {
        loader.frame = CGRect(x: 2*PADDING_8, y: ceil(self.frame.size.height/2) - LoaderSize/2, width: LoaderSize, height: LoaderSize)
        loader.startAnimating()
    }
    
    public func hideLoader() {
        loader.stopAnimating()
    }
    
    

}
