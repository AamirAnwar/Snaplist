//
//  SNSignUpViewController.swift
//  SnapList
//
//  Created by Aamir  on 30/08/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics
class SNSignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var nameTextFieldSeparator = UIView()
    var emailTextFieldSeparator = UIView()
    var passwordTextFieldSeparator = UIView()
    @IBOutlet weak var signUpButton: SNRectButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = 4
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createViews()
    }
    
    func createViews() {
        
        nameTextFieldSeparator.backgroundColor = UIColor.gray
        emailTextFieldSeparator.backgroundColor = UIColor.gray
        passwordTextFieldSeparator.backgroundColor = UIColor.gray
        
        view.addSubview(nameTextFieldSeparator)
        view.addSubview(emailTextFieldSeparator)
        view.addSubview(passwordTextFieldSeparator)
        
        nameTextFieldSeparator.frame = CGRect(x: nameTextField.frame.origin.x, y:  nameTextField.frame.origin.y + nameTextField.frame.height , width:  nameTextField.frame.width, height: 1)
        emailTextFieldSeparator.frame = CGRect(x: emailTextField.frame.origin.x, y:  emailTextField.frame.origin.y + emailTextField.frame.height , width:  emailTextField.frame.width, height: 1)
        passwordTextFieldSeparator.frame = CGRect(x: passwordTextField.frame.origin.x, y:  passwordTextField.frame.origin.y + passwordTextField.frame.height, width:  passwordTextField.frame.width, height: 1)
        
        signUpButton.backgroundColor = UIColor.black
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.titleLabel?.font = SNFTitleBold
    }
    

    @IBAction func createList() {
        signUpButton.isUserInteractionEnabled = false
        signUpButton.showLoader()
        let userEndpoint:URLConvertible = "\(basePath)/user"
        
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            guard !(name.isEmpty || email.isEmpty || password.isEmpty) else {
                self.signUpButton.isUserInteractionEnabled = true
                self.signUpButton.hideLoader()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationDisplayDropdown), object: nil, userInfo: ["message":"Please enter all the fields!"])
                return
            }
            
            let params:[String:Any] = ["name":name,"email":email,"password":password]
            Alamofire.request(userEndpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                // Check response and proceed further
                self.signUpButton.isUserInteractionEnabled = true
                self.signUpButton.hideLoader()
                guard response.result.isSuccess else {
                    print("Error")
                    return
                }
                guard let value = response.result.value as? [String:Any], let userID = value["id"] as? String else {
                    
                    if let value = response.result.value as? [String:Any],let errorMessage = value["err"] as? String {
                        SNHelpers.showDropdownWith(message: errorMessage)
                    }
                    print("Bad Data")
                    return
                }
                print("Registered with ID : \(userID)")
                UserDefaults.standard.set(userID, forKey: KeyUserID)
                
                let addListEndpoint = "\(basePath)/list"
                Alamofire.request(addListEndpoint, method: .post, parameters: ["userId":userID, "title":"My List"], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    guard response.result.isSuccess else {
                        print("Create list API call failed")
                        return
                    }
                    guard let value = response.result.value as? [String:Any], let userID = value["id"] as? String else {
                        if let value = response.result.value as? [String:Any],let errorMessage = value["err"] as? String {
                            SNHelpers.showDropdownWith(message: errorMessage)
                        }
                        return
                    }
                    UserDefaults.standard.set(userID, forKey: KeyListID)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationUserLoggedSuccessfully), object: nil)
                })
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cycleToNextTextField(after: textField)
        return true
    }
    
    func cycleToNextTextField(after textField:UITextField) {
        if textField.isEqual(nameTextField) {
            emailTextField.becomeFirstResponder()
        }
        else if textField.isEqual(emailTextField) {
            passwordTextField.becomeFirstResponder()
        }
        else if textField.isEqual(passwordTextField) {
            passwordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func cancelButtonTapped() {
        Crashlytics.sharedInstance().crash()
        self.dismiss(animated: true, completion: nil)
    }

}
