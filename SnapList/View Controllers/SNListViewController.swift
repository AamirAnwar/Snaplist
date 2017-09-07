//
//  SNListViewController.swift
//  SnapList
//
//  Created by Aamir  on 06/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire

struct ListItem:CustomStringConvertible {
    var title:String
    var content:String
    var description: String {
        return "Item with title:\(title) content:\(content)"
    }
}

class SNListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SNSideMenuViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    var sideMenuView:SNSideMenuView!
    var listItems:Array<ListItem> = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        createSideMenuView()
        configureListTableView()
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(SNListViewController.didTapAddItem)), animated: true)
        self.navigationItem.setLeftBarButton(UIBarButtonItem.init(title: "Menu", style: .plain, target: self, action: #selector(SNListViewController.didTapMenuButton)), animated: true)
        
    }
    
    func createSideMenuView() {
        sideMenuView = SNSideMenuView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        sideMenuView.transform = CGAffineTransform.init(translationX: -sideMenuView.frame.size.width, y: 0)
        sideMenuView.delegate = self
        self.navigationController?.view.addSubview(sideMenuView)
    }
    
    func configureListTableView() {
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 44
        listTableView.backgroundColor = SNLightGray
        listTableView.tableFooterView = UIView()
        listTableView.separatorStyle = .none
        listTableView.register(SNListTableViewCell.self, forCellReuseIdentifier: "listcell")
    }
    
    func registerForNotifications() {
        // Register for notification
        NotificationCenter.default.addObserver(self, selector: #selector(SNListViewController.userLoggedIn), name: NSNotification.Name(rawValue: NotificationUserLoggedSuccessfully), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SNListViewController.itemAdded), name: NSNotification.Name(rawValue: NotificationItemAdded), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if SNHelpers.isUserLoggedIn() == false {
            presentInitialViewController()
        }
    }
    
    func presentInitialViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "initialViewController")
        if let vc = initialViewController as? SNInitialViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func didTapMenuButton() {
        // Show menu here
       sideMenuView.toggleVisibility()

    }
    
    func didTapAddItem(sender:AnyObject) {
        self.present(SNCreateItemViewController(), animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, listItems.count)
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath)
        if let cell = cell as? SNListTableViewCell {
            if listItems.isEmpty {
                cell.titleLabel.text = "Welcome to Snaplist"
                cell.descriptionLabel.text = "Press the add button on the top right to start adding items to your list!"
            }
            else {
                let item = listItems[indexPath.row]
                cell.configureWith(listItem:item)
            }
        }
        
        return cell
    }
    
    func didSelectLogout() {
        SNHelpers.logoutUser()
        presentInitialViewController()
    }
    
    func didSelectJoinList() {
        if let joinListVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SNJoinListViewController") as? SNJoinListViewController {
            self.present(joinListVC, animated: true, completion: nil)
        }
    }
    
    func didSelectInviteOthers() {
        if let inviteOthersVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SNInviteViewController") as? SNInviteViewController {
            self.navigationController?.pushViewController(inviteOthersVC, animated: true)
        }
    }
    
    func didSelectDeleteList() {
        let alertController = UIAlertController.init(title: "Delete List", message: "Are you sure you want to delete this list", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { (action) in
            if let listID = UserDefaults.standard.object(forKey: KeyListID), let userID = UserDefaults.standard.object(forKey: KeyUserID) {
                let deleteListEndPoint = "\(basePath)/list/\(listID)/user/\(userID)"
                Alamofire.request(deleteListEndPoint, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    guard response.result.isSuccess else {
                        SNHelpers.showDropdownWith(message: KFailureMessage)
                        return
                    }
                    
                    guard let responseObject = response.result.value as? [String:Any], let listID = responseObject["id"] else {
                        SNHelpers.showDropdownWith(message: KFailureMessage)
                        return;
                    }
                    print("User removed from list! \(listID)");
                    SNHelpers.logoutUser()
                    self.navigationController?.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "initialViewController"), animated: true, completion: nil)
                    
                })
            }
        }))
        
        alertController.addAction(UIAlertAction.init(title: "No", style: .default, handler: { (action) in
           alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    func refreshList() {
        // Fetch existing items
        if let listID = UserDefaults.standard.value(forKey: KeyListID) {
            let listItemsEndpoint = "\(basePath)/list/\(listID)"
            Alamofire.request(listItemsEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                guard response.result.isSuccess else {
                    return
                }
                
                guard let value = response.result.value as? [String:Any], let listObject = value["list"] as? [String:Any] else {
                    return
                }
                if let shareCode = listObject["shareCode"] {
                    UserDefaults.standard.setValue(shareCode, forKey: KeyShareCode)
                }
                
                if let items = listObject["items"] as? Array<[String:Any]> {
                    self.listItems.removeAll()
                    for item in items {
                        if let item = item as? [String:String] {
                            if let title = item["title"], let content = item["content"] {
                                self.listItems.append(ListItem(title: title, content: content))
                            }
                        }
                    }
                    
                }
                self.listTableView.reloadData()
            }
        }
    }
    
    func userLoggedIn() {
        if let _ = self.presentedViewController {
            self.dismiss(animated: true, completion: nil)
        }
        refreshList()
    }
    
    func itemAdded() {
        refreshList()
    }
}
