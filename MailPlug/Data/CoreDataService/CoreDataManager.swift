//
//  CoreDataManager.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import UIKit
import CoreData

enum CoreDataName {
    static let name = "NSSearch"
}

final class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private init () {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
}
