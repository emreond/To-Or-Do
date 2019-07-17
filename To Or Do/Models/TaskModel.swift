//
//  TaskModel.swift
//  To Or Do Project
//
//  Created by Emre on 21.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var isFav: Bool = false
    @objc dynamic var dueDate: Date?
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var isTodaysDo: Bool = false
    @objc dynamic var isDone: Bool = false
    @objc dynamic var detailNote: String = ""
    @objc dynamic var list: CustomList?
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ title: String, isFav: Bool = false, dueDate: Date? = nil, isTodaysDo: Bool = false) {
        self.init()
        self.title = title
        self.isFav = isFav
        self.dueDate = dueDate
        self.isTodaysDo = isTodaysDo
    }
    
    public func assignToList(list: CustomList){
        self.list = list
    }
}

