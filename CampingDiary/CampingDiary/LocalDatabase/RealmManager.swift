//
//  RealmManager.swift
//  CampingDiary
//
//  Created by 조향래 on 11/9/23.
//

import RealmSwift

final class RealmManager {
    private let realm = try? Realm()
    
    func create(_ data: DataAccessObject) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read(type: DataAccessObject.Type, primaryKey: String) -> DataAccessObject? {
        guard let realm = realm else { return nil }
        
        let data = realm.object(ofType: type, forPrimaryKey: primaryKey)
        
        return data as? DataAccessObject
    }
    
    func readAll(type: DataAccessObject.Type) -> [DataAccessObject]? {
        guard let realm = realm else { return nil }
        
        return realm.objects(type).compactMap { $0 as? DataAccessObject }
    }
    
    func delete(_ data: DataAccessObject) {
        guard let realm = realm,
              let object = read(type: type(of: data), primaryKey: data.primaryKey) else { return }
        
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
