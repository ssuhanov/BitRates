//
//  CoreDataManager.swift
//  BitRates
//
//  Created by Serge Sukhanov on 10/1/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import CoreData

typealias BooleanResultCompletion = (Bool, Error?) -> Void

class CoreDataManager {
    private init() {}
    static let shared = CoreDataManager()
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BitRates")
        container.loadPersistentStores(completionHandler: { (_, error) in
            error.map { print("Load persisten stores failed with error \($0.localizedDescription)") }
        })
        return container
    }()
    
    func getContext() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func saveContext(completion: BooleanResultCompletion? = nil) {
        var contextDidSave = false
        var saveError: Error?
        
        do {
            try persistentContainer.viewContext.save()
            contextDidSave = true
        } catch {
            saveError = error
        }
        
        completion?(contextDidSave, saveError)
    }
}

extension NSManagedObject {
    private static func entityDescription() -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: self), in: CoreDataManager.shared.getContext())
    }
    
    private static func createPrivate<T: NSManagedObject>() -> T? {
        if let entityDescription = entityDescription() {
            return T(entity: entityDescription, insertInto: CoreDataManager.shared.getContext())
        }
        
        return nil
    }
    
    static func create() -> Self? {
        return createPrivate()
    }
    
    static func findAll(sortedBy: String, ascending: Bool = true) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return findAllWithRequest(fetchRequest)
    }
    
    private static func findAllWithRequest(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]? {
        if let results: [NSFetchRequestResult] = try? CoreDataManager.shared.getContext().fetch(fetchRequest) {
            return results as? [NSManagedObject]
        }
        
        return nil
    }
}
