//
//  ListModel.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import RealmSwift

class CustomList: Object {
    @objc dynamic var listName: String = ""
    @objc dynamic var id: String = UUID().uuidString
    var imageName: String = "customlistIcon"
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String) {
        self.init()
        self.listName = name
    }
    
    convenience init(name: String, icon: String) {
        self.init()
        self.listName = name
        self.imageName = icon
    }
    
}
