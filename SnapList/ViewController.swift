//
//  ViewController.swift
//  SnapList
//
//  Created by Aamir  on 08/05/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire

let kpadding13:CGFloat = 13.0
let basePath = "https://snaplist-server.herokuapp.com/api"
let NotificationUserLoggedSuccessfully = "userLoggedInSuccessfully"
let KeyUserID = "USER_ID"
let KeyListID = "LIST_ID"
let LoaderSize:CGFloat = 20
class ViewController: UIViewController {

    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var addListButton:UIButton!
    @IBOutlet weak var joinListButton:UIButton!
    var joinListVC:SNJoinListViewController?
    var loader:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    @IBAction func didTapAddListButton() {
        // Make create API call here
      createList()
    }
    
    @IBAction func didTapJoinListButton() {
        joinListVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SNJoinListViewController") as? SNJoinListViewController
        
        if let vc = joinListVC {
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addListButton.addSubview(loader)
        
        loader.frame = CGRect(x: 2*PADDING_8, y: addListButton.frame.size.height/2 - LoaderSize/2, width: LoaderSize, height: LoaderSize)
    }
    
    func createList() {
        loader.startAnimating()
        self.addListButton.isUserInteractionEnabled = false
        
        let userEndpoint:URLConvertible = "\(basePath)/user"
        
        // Need to figure this out
        let params:[String:Any] = ["name":"aamir","email":"aamir.anwar@gmail.com","password":"aamir"]
        
        Alamofire.request(userEndpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            // Check response and proceed further
            self.addListButton.isUserInteractionEnabled = true
            self.loader.stopAnimating()
            guard response.result.isSuccess else {
                print("Error")
                return
            }
            guard let value = response.result.value as? [String:Any], let userID = value["id"] as? String else {
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
                    print("Bad Data")
                    return
                }
                print(response.result.value!)
                UserDefaults.standard.set(userID, forKey: KeyListID)
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationUserLoggedSuccessfully), object: nil)
            })
            
        }
    }

}



