//
//  UITableView+Extension.swift
//  To Or Do Project
//
//  Created by Emre on 23.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyView(message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plusicon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.sizeToFit()
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        emptyView.addSubview(imageView)
        emptyView.addSubview(messageLabel)
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        messageLabel.anchorCenterXToSuperview()

        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
