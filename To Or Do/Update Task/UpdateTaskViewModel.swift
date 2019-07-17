//
//  AddTaskViewModel.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import Bond
class UpdateTaskViewModel: NSObject {
    
    var title = Observable<String?>(nil)
    var detailNote = Observable<String?>(nil)
    var dueDate = Observable<String?>(nil)

    var isDone = Observable<Bool>(false)
    var isFav = Observable<Bool>(false)
    var isToday = Observable<Bool>(false)
    var createdDate = Observable<String?>(nil)
    
    var task: Task? {
        didSet {
            guard let unwrappedTask = self.task else { return }
            self.title.value = unwrappedTask.title
            self.isDone.value = unwrappedTask.isDone
            self.isFav.value = unwrappedTask.isFav
            self.isToday.value = unwrappedTask.isTodaysDo
            self.detailNote.value = unwrappedTask.detailNote
            self.createdDate.value = DateFormatterHelper.instance.formatDateForDisplay(date: unwrappedTask.createDate)
            if let unwrappedDate = unwrappedTask.dueDate {
                self.dueDate.value = DateFormatterHelper.instance.formatDateForDisplay(date: unwrappedDate)
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    func setDueDateReturnPrettyString(date: Date) -> String {
        let prettyDate = DateFormatterHelper.instance.formatDateForDisplay(date: date)
        self.dueDate.value = prettyDate
        return prettyDate
    }
    
    func updateDatabase() {
        guard let unwrappedTask = self.task else { return }
        let realmObject = RealmManager.init().objectWithID(Task.self, id: unwrappedTask.id) as! Task
        RealmManager.init().update {
            if let unwrappedDateText = self.dueDate.value, let unwrappedDate = DateFormatterHelper.instance.dateFromString(string: unwrappedDateText) {
                realmObject.dueDate = unwrappedDate
            } else {
                realmObject.dueDate = nil
            }
            if let unwrappedText = self.title.value, unwrappedText != "" {
                realmObject.title = unwrappedText
            } else {
                realmObject.title = ""
            }
            if let unwrappedDetailNote = self.detailNote.value, unwrappedDetailNote != "" {
                realmObject.detailNote = unwrappedDetailNote
            } else {
                realmObject.detailNote = ""
            }
            realmObject.isFav = self.isFav.value
            realmObject.isDone = self.isDone.value
            realmObject.isTodaysDo = self.isToday.value
        }
    }
    
    func deleteTask() -> Bool {
        guard let unwrappedTask = self.task else { return false }
        //Do something with the error return
        return RealmManager.init().findAndDeleteObject(Task.self, id: unwrappedTask.id)
    }
    
   
}
