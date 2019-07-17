//
//  KeyboardToolbarButton.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import UIKit

enum KeyboardToolbarButton: Int {
    
    case done = 0
    case cancel
    case back, backDisabled
    case forward, forwardDisabled
    
    func createButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        var button: UIBarButtonItem!
        
        switch self {
        case .back:
            button = UIBarButtonItem(title: "Back", style: .plain, target: target, action: action)
        case .backDisabled:
            button = UIBarButtonItem(title: "Back", style: .plain, target: target, action: action)
            button.isEnabled = false
        case .forward:
            button = UIBarButtonItem(title: "Next", style: .plain, target: target, action: action)
        case .forwardDisabled:
            button = UIBarButtonItem(title: "Next", style: .plain, target: target, action: action)
            button.isEnabled = false
        case .done:
            button = UIBarButtonItem(title: "Done", style: .plain, target: target, action: action)
            button.tintColor = UIColor.white
        case .cancel:
            button = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: action)
            button.tintColor = UIColor.white
        }
        button.tag = rawValue
        button.tintColor = UIColor.white
        return button
    }
    
    static func detectType(barButton: UIBarButtonItem) -> KeyboardToolbarButton? {
        return KeyboardToolbarButton(rawValue: barButton.tag)
    }
}
