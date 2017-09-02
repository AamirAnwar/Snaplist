//
//  SNCreateItemViewController.swift
//  SnapList
//
//  Created by Aamir  on 07/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotification()
        view.backgroundColor = UIColor.white
        createViews()
        layoutViews()
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapBackgroundView))
        containerView.addGestureRecognizer(tapGesture)
    }
    
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
    
    func createViews() {
        createContainerView()
        
        // Set titles
        cancelButton.setTitle("Cancel", for: .normal)
        createButton.setTitle("Create", for: .normal)
        createItemHeadingLabel.text = "Create Item"
        titleLabel.text = "Title"
        descriptionLabel.text = "Description"
        
        // Setup fonts
        createItemHeadingLabel.font = SNFHeadlineBold
        titleLabel.font = SNFTitleBold
        descriptionLabel.font = titleLabel.font
        createButton.titleLabel?.font = SNFTitleBold
        cancelButton.titleLabel?.font = SNFButtonTitleMedium
        descriptionTextView.font = SNFBodyMedium
        titleTextField.font = SNFBodyMedium
        
        // Set Text Alignment
        titleTextField.textAlignment = .center
        descriptionTextView.textAlignment = .center
        
        // Update frames for labels
        createItemHeadingLabel.sizeToFit()
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        
        // Update borders for textview
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        
        // Text field delegate + Line view color
        titleTextField.delegate = self
        titleFieldSeparator.backgroundColor = UIColor.gray
        
        // Create button UI + Target
        createButton.backgroundColor = UIColor.black
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.addTarget(self, action: #selector(SNCreateItemViewController.createButtonTapped), for: .touchUpInside)
        
        // Cancel button UI + Target
        cancelButton.backgroundColor = UIColor.black
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.layer.cornerRadius = 4
        cancelButton.addTarget(self, action: #selector(SNCreateItemViewController.cancelButtonTapped), for: .touchUpInside)
        
        // Add views to container view
        containerView.addSubview(createButton)
        containerView.addSubview(createItemHeadingLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(titleTextField)
        containerView.addSubview(titleFieldSeparator)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(descriptionTextView)
        containerView.addSubview(createButton)
        
        // Setup Scroll View based on container view
        containerScrollView.addSubview(containerView)
        containerScrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(containerScrollView)
        view.addSubview(cancelButton)
    }
    
    func layoutViews() {
        cancelButton.frame = CGRect(x: PADDING_8, y: PADDING_8 + STATUS_BAR_HEIGHT, width: cancelButton.intrinsicContentSize.width + 2*PADDING_8, height: cancelButton.intrinsicContentSize.height)
        
        createItemHeadingLabel.frame = CGRect(x: containerView.center.x - (createItemHeadingLabel.frame.size.width)/2, y: cancelButton.frame.origin.y + cancelButton.frame.size.height + kpadding13, width: createItemHeadingLabel.frame.size.width, height: createItemHeadingLabel.frame.size.height)
        
        titleLabel.frame = CGRect(x: containerView.center.x - (titleLabel.frame.size.width)/2, y: createItemHeadingLabel.frame.origin.y + createItemHeadingLabel.frame.size.height + 3*kpadding13, width: titleLabel.frame.size.width, height: titleLabel.frame.size.height)
        
        titleTextField.frame = CGRect(x: PADDING_8, y: titleLabel.frame.origin.y + titleLabel.frame.size.height, width: containerView.frame.size.width - 2*PADDING_8, height: 40)
        
        titleFieldSeparator.frame = CGRect(x: titleTextField.frame.origin.x, y: titleTextField.frame.origin.y + titleTextField.frame.height - 5, width: titleTextField.frame.width, height: 1)
        
        descriptionLabel.frame = CGRect(x: containerView.center.x - (descriptionLabel.frame.size.width)/2, y: titleTextField.frame.origin.y + titleTextField.frame.size.height + 3*kpadding13 + 5, width: descriptionLabel.frame.size.width, height: descriptionLabel.frame.size.height)
        
        descriptionTextView.frame = CGRect(x: PADDING_8, y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + kpadding13, width: containerView.frame.size.width - 2*PADDING_8, height: 132)
        
        createButton.frame = CGRect(x: PADDING_8, y: descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height + 2*kpadding13, width: containerView.frame.size.width - 2*PADDING_8, height: kButtonHeight)
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
        if let listID = UserDefaults.standard.value(forKey: KeyListID), let title = titleTextField.text, let content = descriptionTextView.text {
            let addItemEndpoint = "\(basePath)/list/\(listID)/item"
            createButton.showLoader()
            createButton.isUserInteractionEnabled = false
            Alamofire.request(addItemEndpoint, method: .post, parameters:["title":title,"content":content], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.createButton.hideLoader()
                self.createButton.isUserInteractionEnabled = true
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
        else {
            SNHelpers.showDropdownWith(message: "Invalid entries!")
        }
    }
    
    // MARK: Dismiss Keyboard Gesture
    func didTapBackgroundView() {
        containerView.endEditing(true)
        disableScroll()
    }
    
    // MARK: Scrolling Helpers
    func enableScroll(notification:NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            let buttonVerticalInfo = (y:createButton.frame.origin.y, height:createButton.frame.height)
            let viewVerticalInfo = (y:containerView.frame.origin.y, height:containerView.frame.height)
            let offsetAdustment = (buttonVerticalInfo.y + buttonVerticalInfo.height) - (viewVerticalInfo.height - keyboardHeight)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.containerScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
                if offsetAdustment > 0.0 && self.descriptionTextView.isFirstResponder {
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
