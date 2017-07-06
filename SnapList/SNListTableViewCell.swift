//
//  SNListTableViewCell.swift
//  SnapList
//
//  Created by Aamir  on 07/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class SNListTableViewCell: UITableViewCell {
    let titleLabel:UILabel
    let descriptionLabel:UILabel
    
    required init?(coder aDecoder: NSCoder) {
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        super.init(coder: aDecoder)
        createViews()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
    }
    
    func createViews() {
        
        titleLabel.text = "Title label one"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        descriptionLabel.text = "Some really long description can really come in handy here! I mean come on just look at this"
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.sizeToFit()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-8),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -20)
            ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:-20)
            ])
    }

}
