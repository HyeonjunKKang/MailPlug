//
//  RecentSearchServiceProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import RxSwift
import CoreData

protocol LocalSearchServiceProtocol {
    func saveRecentSearch(word: String, category: String, date: Date) -> Observable<Void>
    func loadFromCoreData<T: NSManagedObject>(request: NSFetchRequest<T>) -> Observable<[T]>
    func delete<T: NSManagedObject>(search: Search,request: NSFetchRequest<T>) -> Observable<Void>
}

