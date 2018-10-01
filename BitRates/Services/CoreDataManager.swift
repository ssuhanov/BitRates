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
        let container = NSPersistentContainer(name: "UnitedHelp")
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
