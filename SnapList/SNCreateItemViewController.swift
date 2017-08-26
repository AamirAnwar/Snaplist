//
//  SNCreateItemViewController.swift
//  SnapList
//
//  Created by Aamir  on 07/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire
let PADDING_8:CGFloat = 8
let STATUS_BAR_HEIGHT:CGFloat = 22
let kButtonHeight:CGFloat = 50
let KeyShareCode = "SHARE_CODE"
let NotificationItemAdded = "NotificationItemAdded"
class SNCreateItemViewController: UIViewController, UITextFieldDelegate {
    
    let cancelButton = UIButton(type: UIButtonType.system)
    let createItemHeadingLabel = UILabel()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let descriptionLabel = UILabel()
    let descriptionTextView = UITextView()
    let createButton = SNRectButton(type: UIButtonType.system)
    let containerView = UIView()
    let containerScrollView = UIScrollView()
    let titleFieldSeparator = UIView()
    
    func registerForNotification() {
        NotificationCenter.default.addObserver(self, selector:#selector(SNCreateItemViewController.willShowKeyboard(notification:)) , name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(SNCreateItemViewController.willHideKeyboard) , name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func createContainerView() {
        containerView.frame = view.frame
        containerView.backgroundColor = UIColor.white
        containerScrollView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + STATUS_BAR_HEIGHT, width: view.frame.size.width, height: view.frame.size.height - STATUS_BAR_HEIGHT)
        containerScrollView.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotification()
        view.backgroundColor = UIColor.white
        createContainerView()
        cancelButton.setTitle("Cancel", for: .normal)
        createButton.setTitle("Create", for: .normal)
        
        createItemHeadingLabel.text = "Create Item"
        titleLabel.text = "Title"
        descriptionLabel.text = "Description"
        
        createItemHeadingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        descriptionLabel.font = titleLabel.font
        createButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        descriptionTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        titleTextField.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        
        createItemHeadingLabel.sizeToFit()
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        
        
        titleTextField.delegate = self
        
        titleFieldSeparator.backgroundColor = UIColor.gray

        
        createButton.backgroundColor = UIColor.black
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.addTarget(self, action: #selector(SNCreateItemViewController.createButtonTapped), for: .touchUpInside)
        
        cancelButton.backgroundColor = UIColor.black
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.layer.cornerRadius = 4
        cancelButton.addTarget(self, action: #selector(SNCreateItemViewController.cancelButtonTapped), for: .touchUpInside)

        view.addSubview(cancelButton)
        containerView.addSubview(createButton)
        containerView.addSubview(createItemHeadingLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(titleTextField)
        containerView.addSubview(titleFieldSeparator)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(descriptionTextView)
        containerView.addSubview(createButton)
        containerScrollView.addSubview(containerView)
        containerScrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(containerScrollView)
        view.bringSubview(toFront: cancelButton)
        
        cancelButton.frame = CGRect(x: PADDING_8, y: PADDING_8 + STATUS_BAR_HEIGHT, width: cancelButton.intrinsicContentSize.width + 2*PADDING_8, height: cancelButton.intrinsicContentSize.height)
        
        createItemHeadingLabel.frame = CGRect(x: containerView.center.x - (createItemHeadingLabel.frame.size.width)/2, y: cancelButton.frame.origin.y + cancelButton.frame.size.height + kpadding13, width: createItemHeadingLabel.frame.size.width, height: createItemHeadingLabel.frame.size.height)
        
        titleLabel.frame = CGRect(x: containerView.center.x - (titleLabel.frame.size.width)/2, y: createItemHeadingLabel.frame.origin.y + createItemHeadingLabel.frame.size.height + 3*kpadding13, width: titleLabel.frame.size.width, height: titleLabel.frame.size.height)
        
        titleTextField.frame = CGRect(x: PADDING_8, y: titleLabel.frame.origin.y + titleLabel.frame.size.height, width: containerView.frame.size.width - 2*PADDING_8, height: 40)
        
        titleFieldSeparator.frame = CGRect(x: titleTextField.frame.origin.x, y: titleTextField.frame.origin.y + titleTextField.frame.height - 5, width: titleTextField.frame.width, height: 1)
        
        descriptionLabel.frame = CGRect(x: containerView.center.x - (descriptionLabel.frame.size.width)/2, y: titleTextField.frame.origin.y + titleTextField.frame.size.height + 3*kpadding13 + 5, width: descriptionLabel.frame.size.width, height: descriptionLabel.frame.size.height)
        
        descriptionTextView.frame = CGRect(x: PADDING_8, y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + kpadding13, width: containerView.frame.size.width - 2*PADDING_8, height: 132)
        
        createButton.frame = CGRect(x: PADDING_8, y: descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height + 2*kpadding13, width: containerView.frame.size.width - 2*PADDING_8, height: kButtonHeight)
        
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapBackgroundView))
        containerView.addGestureRecognizer(tapGesture)
        
        

    }
    
    func willShowKeyboard(notification:NSNotification) {
        enableScroll(notification: notification)
        
    }
    
    func willHideKeyboard() {
        disableScroll()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func cancelButtonTapped() {
        self.descriptionTextView.resignFirstResponder()
        self.titleLabel.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func createButtonTapped() {
        // Add item API call
        let addItemEndpoint = "\(basePath)/list/\(UserDefaults.standard.value(forKey: KeyListID)!)/item"
        let title:String = titleTextField.text!
        let content:String = descriptionTextView.text!
        createButton.showLoader()
        Alamofire.request(addItemEndpoint, method: .post, parameters:["title":title,"content":content], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            self.createButton.hideLoader()
            guard response.result.isSuccess else {
                return
            }
            guard let value = response.result.value as? [String:Any], let shareCode = value["shareCode"] as? String else {
                return
            }
            // Refresh list page. TODO - Add locally and then sync with server (Possible diffing? IGListKit use case)
            UserDefaults.standard.setValue(shareCode, forKey: KeyShareCode)
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: NotificationItemAdded), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didTapBackgroundView() {
        containerView.endEditing(true)
        disableScroll()
    }
    
    func enableScroll(notification:NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            let buttonVerticalInfo = (y:createButton.frame.origin.y, height:createButton.frame.height)
            let viewVerticalInfo = (y:containerView.frame.origin.y, height:containerView.frame.height)
            let offsetAdustment = (buttonVerticalInfo.y + buttonVerticalInfo.height) - (viewVerticalInfo.height - keyboardHeight)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.containerScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
                if offsetAdustment > 0.0 {
                 self.containerScrollView.setContentOffset(CGPoint.init(x: self.containerScrollView.contentOffset.x, y: offsetAdustment + kButtonHeight/2), animated: true)
                }
            }, completion: { (finished) in
                self.containerScrollView.isScrollEnabled = true
            })
        }
        
    }
    
    func disableScroll() {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerScrollView.contentInset = .zero
        }, completion: { (finished) in
            self.containerScrollView.isScrollEnabled = false
        })
    }
    
}
