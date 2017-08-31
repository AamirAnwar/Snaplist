//
//  SNNotificationDropdown.swift
//  SnapList
//
//  Created by Aamir  on 30/08/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class SNNotificationDropdown: UIView {
    var messageLabel = UILabel()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        
        // Setup all view properties
        self.backgroundColor = UIColor.black
        self.addSubview(messageLabel)
        messageLabel.font = SNFBodyMedium
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 1
        
    }
    
    func setMessage(_ message:String ) {
        messageLabel.text = message
        messageLabel.sizeToFit()
        messageLabel.frame = CGRect(x: PADDING_8, y: self.frame.height/2 - messageLabel.frame.height/2, width: self.frame.width - 2*PADDING_8, height: messageLabel.frame.height)
    }
    
    func show() {
        if self.layer.animationKeys()?.isEmpty == false {
            return
        }
        
        if let window = UIApplication.shared.delegate?.window {
            self.transform = self.transform.translatedBy(x: 0, y:-self.frame.height)
            window?.addSubview(self)
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    func hide() {
        if self.layer.animationKeys()?.isEmpty == false {
            return
        }
        if let _ = self.superview {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = self.transform.translatedBy(x: 0, y:-self.frame.height)
            }, completion: { (finished) in
                self.removeFromSuperview()
            })
        }
    }
    
    
    
}
