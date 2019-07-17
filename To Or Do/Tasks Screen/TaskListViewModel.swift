//
//  TaskListViewModel.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import RealmSwift

class TaskListViewModel: NSObject {
    
    var list = GenericDataSource<Task>()
    
    var type: ListType
    
    init(listType: ListType) {
        self.type = listType
    }
    
    func viewModelForTask(at index: Int) -> Task? {
        guard index < list.data.value.count else {
            return nil
        }
        return list.data.value[index]
    }
    
    func addModel(title: String, customList: CustomList?) {
        let task = Task(title, isFav: type == .fav ? true : false, dueDate: nil, isTodaysDo: type == .today ? true : false)
        if type == .other, let unwrappedCustomList = customList{
            task.assignToList(list: unwrappedCustomList)
        }
        list.data.value.append(task)
        RealmManager.init().add([task])
    }
    
    func removeTask(at index: Int) {
        let task = list.data.value[index]
        list.data.value.remove(at: index)
        _ = RealmManager.init().findAndDeleteObject(Task.self, id: task.id)
    }
    
    func updateModel(with id: String) {
        if let filteredData = self.list.data.value.filter( {$0.id == id }).first {
            RealmManager.init().update {
                filteredData.isDone = !filteredData.isDone
            }
        }
    }
    
    func fetchList(customListName: String?) {
        self.list.data.value = []
        switch type {
        case .today:
            self.list.data.value = RealmManager().getAllDataWithPredictType(PredictTypes.todaytasks, T: Task.self) as! [Task]
        case .fav:
            self.list.data.value = RealmManager().getAllDataWithPredictType(PredictTypes.favtasks, T: Task.self) as! [Task]
        case .all:
            self.list.data.value = RealmManager().getAllDataForObject(Task.self) as! [Task]
        case .other:
            self.list.data.value = RealmManager().getAllDataWithPredictType(PredictTypes.customList(listName: customListName ?? ""), T: Task.self) as! [Task]
        }
    }
}
