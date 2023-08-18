//
//  RecentSearchService.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import Foundation
import CoreData
import RxSwift

struct LocalSearchService: LocalSearchServiceProtocol {
    let manager = CoreDataManager.shared
    
    func saveRecentSearch(word: String, category: String, date: Date) -> Observable<Void> {
        return Observable.create { emitter in
            
            guard let context = manager.context,
                  let entity = NSEntityDescription.entity(forEntityName: CoreDataName.name, in: context) else
            { return Disposables.create() }
            
            guard let recent = NSManagedObject(entity: entity, insertInto: context) as? NSSearch else
            { return Disposables.create() }
            
            recent.word = word
            recent.category = category
            recent.date = date
            
            do {
                try context.save()
                emitter.onNext(())
            } catch {
                print("RecentSearchService")
                print(error.localizedDescription)
                emitter.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func loadFromCoreData<T: NSManagedObject>(request: NSFetchRequest<T>) -> Observable<[T]> {
        
        return Observable.create { emitter in
            guard let context = manager.context else {
                return Disposables.create()
            }
            
            do {
                let results = try context.fetch(request)
                emitter.onNext(results)
            } catch {
                print(error.localizedDescription)
                emitter.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func delete<T: NSManagedObject>(search: Search,request: NSFetchRequest<T>) -> Observable<Void> {
        
        return Observable.create { emitter in
            request.predicate = NSPredicate(format: "category == %@ AND word == %@", search.category.rawValue, search.word)
            
            guard let context = manager.context else {
                return Disposables.create()
            }
            do {
                let matchingObjects = try context.fetch(request)
                if matchingObjects.count > 0 {
                    context.delete(matchingObjects[0])
                }
                try context.save()
                emitter.onNext(())
                
            } catch {
                print(error.localizedDescription)
                emitter.onError(error)
            }
            return Disposables.create()
        }
        
    }
}
