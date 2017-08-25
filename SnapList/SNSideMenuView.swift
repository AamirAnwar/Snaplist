//
//  SNSideMenuView.swift
//  SnapList
//
//  Created by Aamir  on 11/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

public protocol SNSideMenuViewDelegate:NSObjectProtocol {
    func didSelectInviteOthers() -> Void
    func didSelectDeleteList() -> Void
}

class SNSideMenuView: UIView, UITableViewDelegate,UITableViewDataSource {
    
    
    var sideMenuTableView:UITableView
    var containerView = UIView()
    var backgroundView = UIView()
    var headingLabel = UILabel()
    var tableViewData = Array<String>()
    weak var delegate:SNSideMenuViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        sideMenuTableView = UITableView(frame: CGRect.zero, style: .plain)
        
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        containerView.frame = CGRect(x: 0, y: 0, width: frame.size.width*0.7, height: frame.size.height)
        backgroundView.frame = frame
        sideMenuTableView = UITableView(frame: containerView.frame, style: .plain)
        super.init(frame: frame)
        
        
        self.addSubview(backgroundView)
        
        containerView.backgroundColor = UIColor.white
        self.addSubview(containerView)
        
        
        
        headingLabel.text = "Snaplist"
        headingLabel.sizeToFit()
        headingLabel.frame = CGRect(x: containerView.center.x - headingLabel.frame.size.width/2 , y: containerView.frame.origin.y + 2*kpadding13 + STATUS_BAR_HEIGHT, width: headingLabel.frame.size.width, height: headingLabel.frame.size.height)
        headingLabel.textColor = UIColor.black
        containerView.addSubview(headingLabel)
        
        
        sideMenuTableView.dataSource = self
        sideMenuTableView.frame = CGRect(x: sideMenuTableView.frame.origin.x, y: headingLabel.frame.origin.y + headingLabel.frame.size.height + PADDING_8, width: sideMenuTableView.frame.size.width, height: sideMenuTableView.frame.size.height)
        sideMenuTableView.delegate = self
        sideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SideMenuTableViewCell")
        sideMenuTableView.tableFooterView = UIView()
        sideMenuTableView.rowHeight = 88
        containerView.addSubview(sideMenuTableView)
        
        
        backgroundView.backgroundColor = UIColor.clear
        
        
        tableViewData.append("Invite Others")
        tableViewData.append("Delete List")
        
        
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(SNSideMenuView.didTapBackground)))
        
    }
    
    func didTapBackground() -> Void {
        toggleVisibility()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath)
        cell.textLabel?.text = tableViewData[indexPath.row]
        if indexPath.row == 1 {
            cell.textLabel?.textColor = UIColor.red.withAlphaComponent(0.8)
        }
        cell.textLabel?.textAlignment = .center
        return cell
        
    }
    
    func toggleVisibility() {
        
        if self.transform.isIdentity {
            // Hide
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.backgroundColor = UIColor.clear
                self.containerView.transform = CGAffineTransform.init(translationX: -self.containerView.frame.width, y: 0)
            }, completion: { (finished) in
                self.transform = CGAffineTransform.init(translationX: -self.frame.size.width, y: 0)
            })
        }
        else {
            // Show
            self.backgroundView.backgroundColor = UIColor.clear
            containerView.transform = CGAffineTransform.init(translationX: -containerView.frame.width, y: 0)
            self.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.containerView.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleVisibility()
        switch indexPath.row {
        case 0:
            delegate?.didSelectInviteOthers()
        case 1:
            delegate?.didSelectDeleteList()
        default:
            return
        }
    }
    

}
