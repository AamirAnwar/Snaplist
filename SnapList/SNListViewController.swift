//
//  SNListViewController.swift
//  SnapList
//
//  Created by Aamir  on 06/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class SNListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SNSideMenuViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    var sideMenuView:SNSideMenuView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuView = SNSideMenuView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        sideMenuView.transform = CGAffineTransform.init(translationX: -sideMenuView.frame.size.width, y: 0)
        sideMenuView.delegate = self
        self.navigationController?.view.addSubview(sideMenuView)
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 44
        listTableView.register(SNListTableViewCell.self, forCellReuseIdentifier: "listcell")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "initialViewController")
        
        if let vc = initialViewController as? ViewController {
            self.present(vc, animated: true, completion: nil)
        }
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(SNListViewController.didTapAddItem)), animated: true)
        self.navigationItem.setLeftBarButton(UIBarButtonItem.init(title: "Menu", style: .plain, target: self, action: #selector(SNListViewController.didTapMenuButton)), animated: true)
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = listTableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? SNListTableViewCell
        if cell == nil {
            cell = SNListTableViewCell.init(style: .default, reuseIdentifier: "listcell")
        }
        
        return cell!
    }
    
    func didSelectInviteOthers() {
        if let inviteOthersVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SNInviteViewController") as? SNInviteViewController {
            self.navigationController?.pushViewController(inviteOthersVC, animated: true)
        }
    }
    
    func didSelectDeleteList() {
        let alertController = UIAlertController.init(title: "Delete List", message: "Are you sure you want to delete this list", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { (action) in
            self.navigationController?.present(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "initialViewController"), animated: true, completion: nil)
        }))
        
        
        alertController.addAction(UIAlertAction.init(title: "No", style: .default, handler: { (action) in
           alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
}
