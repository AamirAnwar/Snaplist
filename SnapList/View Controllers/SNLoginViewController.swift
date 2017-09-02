//
//  SNLoginViewController.swift
//  SnapList
//
//  Created by Aamir  on 02/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire
class SNLoginViewController: UIViewController {
    var emailTextFieldSeparator = UIView()
    var passwordTextFieldSeparator = UIView()
    
    @IBOutlet weak var loginButton: SNRectButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createViews()
    }
    
    func createViews() {
        emailTextFieldSeparator.backgroundColor = UIColor.gray
        passwordTextFieldSeparator.backgroundColor = UIColor.gray
        view.addSubview(emailTextFieldSeparator)
        view.addSubview(passwordTextFieldSeparator)
        emailTextFieldSeparator.frame = CGRect(x: emailTextField.frame.origin.x, y:  emailTextField.frame.origin.y + emailTextField.frame.height , width:  emailTextField.frame.width, height: 1)
        passwordTextFieldSeparator.frame = CGRect(x: passwordTextField.frame.origin.x, y:  passwordTextField.frame.origin.y + passwordTextField.frame.height, width:  passwordTextField.frame.width, height: 1)
        loginButton.backgroundColor = UIColor.black
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = SNFTitleBold
    }
    
    @IBAction func loginButtonTapped(_ sender: SNRectButton) {
        if let emailID = emailTextField.text, let password = passwordTextField.text {
            guard (emailID.isEmpty || password.isEmpty) == false else {
                SNHelpers.showDropdownWith(message: "Please enter all the fields")
                return;
            }
            let loginEndpoint = "\(basePath)/auth"
            let params = ["email":emailID, "password":password]
            loginButton.showLoader()
            loginButton.isUserInteractionEnabled = false
            Alamofire.request(loginEndpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                self.loginButton.isUserInteractionEnabled = true
                self.loginButton.hideLoader()
                
                guard response.result.isSuccess else {
                    SNHelpers.showDropdownWith(message: "Something went wrong")
                    return
                }
                guard let responseObject = response.result.value as? [String:Any] else {
                    SNHelpers.showDropdownWith(message: "Something went wrong")
                    self.loginButton.hideLoader()
                    return
                }
                
                if let userID = responseObject["id"] {
                    //Store UserID
                    UserDefaults.standard.setValue(userID, forKey: KeyUserID)
                    
                    let getUserEndpoint = "\(basePath)/user/\(userID)"
                    Alamofire.request(getUserEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                        guard response.result.isSuccess else {
                            SNHelpers.showDropdownWith(message: "Something went wrong")
                            self.loginButton.hideLoader()
                            return
                        }
                        guard let responseObject = response.result.value as? [String:Any] else {
                            SNHelpers.showDropdownWith(message: "Something went wrong")
                            self.loginButton.hideLoader()
                            return
                        }
                        
                        if let user = responseObject["user"] as? [String:Any], let lists = user["lists"] as? [String] {
                            if let listID = lists.first {
                                UserDefaults.standard.setValue(listID, forKey: KeyListID)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationUserLoggedSuccessfully), object: nil)
                            }
                            else {
                                // Make create list API Call
                                let addListEndpoint = "\(basePath)/list"
                                Alamofire.request(addListEndpoint, method: .post, parameters: ["userId":userID, "title":"My List"], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                                    guard response.result.isSuccess else {
                                        print("Create list API call failed")
                                        self.loginButton.hideLoader()
                                        return
                                    }
                                    guard let value = response.result.value as? [String:Any], let userID = value["id"] as? String else {
                                        if let value = response.result.value as? [String:Any],let errorMessage = value["err"] as? String {
                                            SNHelpers.showDropdownWith(message: errorMessage)
                                        }
                                        self.loginButton.hideLoader()
                                        return
                                    }
                                    UserDefaults.standard.set(userID, forKey: KeyListID)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationUserLoggedSuccessfully), object: nil)
                                })
                            }
                        }
                    })
                    self.loginButton.hideLoader()
                }
                else {
                    self.loginButton.hideLoader()
                    SNHelpers.showDropdownWith(message: "Something went wrong")
                }
            })
        }
    }
    
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
