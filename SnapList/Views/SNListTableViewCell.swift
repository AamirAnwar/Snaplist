//
//  SNListTableViewCell.swift
//  SnapList
//
//  Created by Aamir  on 07/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class SNListTableViewCell: UITableViewCell {
    
    let titleLabel:UILabel = UILabel()
    let descriptionLabel:UILabel = UILabel()
    let containerView = UIView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .none
        createViews()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
    }
    
    func createViews() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = SNFTitleMedium
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = SNFParagraph
        descriptionLabel.sizeToFit()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        containerView.addSubview(descriptionLabel)
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:ceil(kpadding13/2)),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ceil(kpadding13/2)),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant:kpadding13),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:-kpadding13),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -20)
            ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant:kpadding13),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:-kpadding13),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant:-20)
            ])
    }

}
