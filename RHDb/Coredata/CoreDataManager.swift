//
//  CoreDataManager.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataManager: class {
    associatedtype T: NSManagedObject
}

extension CoreDataManager {
    
    private var context: NSManagedObjectContext {
        return AppDelegate().sharedInstance().persistentContainer.viewContext
    }

    // CRUD: Create, Read, Update, Delete
    
    func newEntity() -> T {
        // swiftlint:disable force_cast
        return NSEntityDescription.insertNewObject(forEntityName: T.description(), into: context) as! T
        // swiftlint:enable force_cast
    }
    
    func fetchData(_ predicate: NSPredicate? = NSPredicate(format: "TRUEPREDICATE"), sortBy sortDescriptor: NSSortDescriptor? = nil) -> [T]? {
        
        let fetch = NSFetchRequest<T>(entityName: T.description())
        fetch.predicate = predicate

        if let sortDescriptor = sortDescriptor {
            fetch.sortDescriptors = [sortDescriptor]
        }
        
        do {
            let resultSet: [T] = try context.fetch(fetch)
            return resultSet
        } catch {
            print(#function, error)
        }
        
        return nil
    }
    
    func update(_ object: T) {
        self.saveContext()
    }
    
    func delete(_ object: T) {
        context.delete(object)
        self.saveContext()
    }
    
    func delete(_ objects: [T]) {
        objects.forEach { context.delete($0) }
        self.saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
