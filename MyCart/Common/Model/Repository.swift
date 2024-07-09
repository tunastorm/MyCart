//
//  Repository.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import Foundation
import RealmSwift


// complitionHandler를 이용해 완료 후의 작업 처리와 에러처리 동시 구현 가능할 것
final class TodoRepository {
    
    typealias RepositoryResult = (_ status: RepositoryStatus?, _ error: RepositoryError?) -> Void
    typealias PropertyUpdate = () -> Void
    
    private let realm = try! Realm()

    func createItem(_ data: Object, complitionHandler: RepositoryResult) {
        do {
            try realm.write {
                realm.add(data)
            }
            complitionHandler(RepositoryStatus.createSuccess, nil)
        } catch {
            complitionHandler(nil, RepositoryError.createFailed)
        }
    }
    
    func fetchItem<T:Object>(object: T.Type, primaryKey: ObjectId) -> T? {
        return realm.object(ofType: object, forPrimaryKey: primaryKey)
    }
    
    func fetchAll<T: Object>(obejct: T.Type, sortKey column: ColumnManager, acending: Bool = true) -> [T] {
        let value = realm.objects(obejct).sorted(byKeyPath: column.name, ascending: acending)
        return Array(value)
    }
    
    func fetchAllFiltered<T: Object>(obejct: T.Type, sortKey column: ColumnManager, acending: Bool = true, query: (Query<T>) -> Query<Bool>) -> [T] {
        let value = realm.objects(obejct).where(query).sorted(byKeyPath: column.name, ascending: acending)
        return Array(value)
    }
    
    func searchCompoundedFilter<T:Object>(objet: T.Type, sortKey column: ColumnManager, acending: Bool = true, compoundPredicate: NSCompoundPredicate, filter: (Query<T>) -> Query<Bool>) -> [T] {
        let value = realm.objects(objet).where(filter).filter(compoundPredicate).sorted(byKeyPath: column.name, ascending: acending)
        print(#function, value)
        return Array(value)
    }
    
    func updateItem<T:Object>(object: T.Type, complitionHandler: RepositoryResult) {
        do {
            try realm.write {
                realm.create(object, update: .modified)
            }
            complitionHandler(RepositoryStatus.updateSuccess, nil)
        } catch {
            complitionHandler(nil, RepositoryError.updatedFailed)
        }
    }
    
    func updateProperty(updateHandeler: PropertyUpdate, completionHandler: RepositoryResult) {
        do {
            try realm.write {
                updateHandeler()
            }
            completionHandler(RepositoryStatus.updateSuccess, nil)
        } catch {
            completionHandler(nil, RepositoryError.updatedFailed)
        }
    }
    
    func deleteItem(_ data: Object, fileName: String? = nil, complitionHandler: RepositoryResult) {
        if let fileName {
            Utils.resourceManager.removeImageFromDocument(filename: fileName)
        }
        do {
            try realm.write {
                realm.delete(data)
            }
            complitionHandler(RepositoryStatus.deleteSuccess, nil)
        } catch {
            complitionHandler(nil, RepositoryError.deleteFailed)
        }
    }
}
