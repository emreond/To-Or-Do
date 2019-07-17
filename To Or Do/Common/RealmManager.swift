//
//  RealmManager.swift
//  To Or Do Project
//
//  Created by Emre on 21.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import RealmSwift

public enum PredictTypes {
    case favtasks
    case todaytasks
    case alltasks
    case customList(listName: String)
    
    var rawValue: String {
        switch self {
        case .favtasks: return "isFav == YES"
        case .todaytasks: return "isTodaysDo == YES"
        case .alltasks: return ""
        case .customList(let listName): return "list.listName == '\(listName)'"
        }
    }
}

final class RealmManager: NSObject {
    
    private let realmObject: Realm
    
    override init(){
        realmObject = try! Realm()
    }
    
    func getAllDataForObject(_ T : Object.Type) -> [Object] {
        
        var objects = [Object]()
        for result in realmObject.objects(T) {
            objects.append(result)
        }
        return objects
    }
    
    func getAllDataWithPredictType(_ predictType: PredictTypes, T : Object.Type) -> [Object] {
        
        var objects = [Object]()
        let p1 = NSPredicate(format: predictType.rawValue)
        for result in realmObject.objects(T).filter(p1) {
            objects.append(result)
        }
        return objects
    }
    
    func deleteAllDataForObject(_ T : Object.Type) {
        
        self.delete(self.getAllDataForObject(T))
    }
    
    func replaceAllDataForObject(_ T : Object.Type, with objects : [Object]) {
        
        deleteAllDataForObject(T)
        add(objects)
    }
    
    
    func add(_ objects : [Object], completion : @escaping() -> ()) {
        
        try! realmObject.write{
            realmObject.add(objects, update: Realm.UpdatePolicy.modified)
            completion()
        }
    }
    
    func add(_ objects : [Object]) {
        
        try! realmObject.write{
            realmObject.add(objects, update: Realm.UpdatePolicy.modified)
        }
    }
    
    func findAndDeleteObject(_ T: Object.Type, id: String) -> Bool {
        guard let unwrappedObject = self.objectWithID(T, id: id) else { return false }
        self.delete([unwrappedObject])
        return true
    }
    
    func objectWithID(_ T: Object.Type, id: String) -> Object? {
        return realmObject.object(ofType: T, forPrimaryKey: id)
    }
    
    func update(_ block: @escaping ()->Void) {
        
        try! realmObject.write(block)
    }
    
    func delete(_ objects : [Object]) {
        
        try! realmObject.write{
            realmObject.delete(objects)
        }
    }
}
