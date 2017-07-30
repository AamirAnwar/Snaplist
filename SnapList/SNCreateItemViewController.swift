//
//  SNCreateItemViewController.swift
//  SnapList
//
//  Created by Aamir  on 07/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
let PADDING_8:CGFloat = 8
let STATUS_BAR_HEIGHT:CGFloat = 22
class SNCreateItemViewController: UIViewController, UITextFieldDelegate {
    
    let cancelButton = UIButton(type: UIButtonType.system)
    let createItemHeadingLabel = UILabel()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let descriptionLabel = UILabel()
    let descriptionTextView = UITextView()
    let createButton = UIButton(type: UIButtonType.system)
    let containerView = UIView()
    let containerScrollView = UIScrollView()
    
    
    func registerForNotification() {
        NotificationCenter.default.addObserver(self, selector:#selector(SNCreateItemViewController.willShowKeyboard) , name: Notification.Name.UIKeyboardWillShow, object: nil)
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
        
        createItemHeadingLabel.sizeToFit()
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.borderWidth = 1
        
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.delegate = self
        
        createButton.backgroundColor = UIColor.black
        createButton.setTitleColor(UIColor.white, for: .normal)
        
        cancelButton.backgroundColor = UIColor.black
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.layer.cornerRadius = 4
        cancelButton.addTarget(self, action: #selector(SNCreateItemViewController.cancelButtonTapped), for: .touchUpInside)

        view.addSubview(cancelButton)
        containerView.addSubview(createButton)
        containerView.addSubview(createItemHeadingLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(titleTextField)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(descriptionTextView)
        containerView.addSubview(createButton)
        containerScrollView.addSubview(containerView)
        containerScrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(containerScrollView)
        view.bringSubview(toFront: cancelButton)
        
        cancelButton.frame = CGRect(x: PADDING_8, y: PADDING_8 + STATUS_BAR_HEIGHT, width: cancelButton.intrinsicContentSize.width + 2*PADDING_8, height: cancelButton.intrinsicContentSize.height)
        
        createItemHeadingLabel.frame = CGRect(x: containerView.center.x - (createItemHeadingLabel.frame.size.width)/2, y: cancelButton.frame.origin.y + cancelButton.frame.size.height + kpadding13, width: createItemHeadingLabel.frame.size.width, height: createItemHeadingLabel.frame.size.height)
        
        titleLabel.frame = CGRect(x: containerView.center.x - (titleLabel.frame.size.width)/2, y: createItemHeadingLabel.frame.origin.y + createItemHeadingLabel.frame.size.height + kpadding13, width: titleLabel.frame.size.width, height: titleLabel.frame.size.height)
        
        titleTextField.frame = CGRect(x: PADDING_8, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + kpadding13, width: containerView.frame.size.width - 2*PADDING_8, height: 44)
        
        descriptionLabel.frame = CGRect(x: containerView.center.x - (descriptionLabel.frame.size.width)/2, y: titleTextField.frame.origin.y + titleTextField.frame.size.height + kpadding13, width: descriptionLabel.frame.size.width, height: descriptionLabel.frame.size.height)
        
        descriptionTextView.frame = CGRect(x: PADDING_8, y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + kpadding13, width: containerView.frame.size.width - 2*PADDING_8, height: 132)
        
        createButton.frame = CGRect(x: PADDING_8, y: descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height + kpadding13, width: containerView.frame.size.width - 2*PADDING_8, height: createButton.intrinsicContentSize.height)
        

    }
    
    func willShowKeyboard() {
        containerScrollView.setContentOffset(CGPoint(x:containerScrollView.contentOffset.x,y:40), animated: true)
        
    }
    
    func willHideKeyboard() {
        containerScrollView.setContentOffset(CGPoint(x:containerScrollView.contentOffset.x,y:0), animated: true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func cancelButtonTapped() {
        self.descriptionTextView.resignFirstResponder()
        self.titleLabel.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
}
