//
//  AddNewView.swift
//  To Or Do Project
//
//  Created by Emre on 23.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit

class AddNewView: UIView {
    
    private let icon = UIImageView()
    let label = UITextField()
    
    var iconImage: UIImage? {
        didSet {
            self.icon.image = iconImage!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(icon: UIImage) {
        self.init()
        self.iconImage = icon
        self.icon.image = icon
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        icon.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(icon)
        self.addSubview(label)
        
        icon.tintColor = Colors.iconsColor
        label.textColor = Colors.darkTextColor

        icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.label.centerYAnchor).isActive = true

        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
}
