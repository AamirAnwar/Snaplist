//
//  SNListViewController.swift
//  SnapList
//
//  Created by Aamir  on 06/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class SNListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 44
        listTableView.register(SNListTableViewCell.self, forCellReuseIdentifier: "listcell")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "initialViewController")
        
        if let vc = initialViewController as? ViewController {
            self.present(vc, animated: true, completion: nil)
        }
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(didTapAddItem)), animated: true)
        
        
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
}
