//
//  NSSearch+CoreDataProperties.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//
//

import Foundation
import CoreData


extension NSSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSSearch> {
        return NSFetchRequest<NSSearch>(entityName: "NSSearch")
    }

    @NSManaged public var category: String?
    @NSManaged public var word: String?
    @NSManaged public var date: Date?
    
    func toDomain() -> Search? {
            guard let categoryString = category,
                  let category = SearchCategory(rawValue: categoryString),
                  let word = word,
                  let date = date else {
                return nil
            }

            return Search(category: category, word: word, date: date)
        }

}

extension NSSearch : Identifiable {

}
