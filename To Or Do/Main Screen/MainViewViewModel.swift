//
//  MainViewViewModel.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import RealmSwift
class MainViewListViewModel: NSObject {
    
    var stickyTableViewItems = GenericDataSource<CustomList>()
    var customList = GenericDataSource<CustomList>()
    
    override init() {
        super.init()
        let m1 = CustomList(name: "My Day", icon: "myday")
        let m2 = CustomList(name: "Important", icon: "star")
        let m3 = CustomList(name: "All Tasks", icon: "alltasks")
        stickyTableViewItems.data.value = [m1,m2,m3]
    }
    
    func viewModelForStickyList(at index: Int) -> CustomList? {
        guard index < stickyTableViewItems.data.value.count else {
            return nil
        }
        return stickyTableViewItems.data.value[index]
    }
    
    func viewModelForCustomList(at index: Int) -> CustomList? {
        guard index < customList.data.value.count else {
            return nil
        }
        return customList.data.value[index]
    }
    
    func removeCustomListItem(at index: Int) {
        _ = RealmManager.init().findAndDeleteObject(CustomList.self, id: customList.data.value[index].id)
        customList.data.value.remove(at: index)
    }
    
    func fetchCustomList() {
        self.customList.data.value = RealmManager().getAllDataForObject(CustomList.self) as! [CustomList]
    }
    
    func addCustomList(taskName: String) {
        let customList = CustomList.init(name: taskName)
        self.customList.data.value.append(customList)
        RealmManager.init().add([customList])
    }
    
    func selectedTaskType(section: Int, indexPath: Int) -> ListType {
        if section == 0 {
            if indexPath == 0 {
                return ListType.today
            } else if indexPath == 1 {
                return ListType.fav
            } else {
                return ListType.all
            }
        } else {
            return ListType.other
        }
    }
}
