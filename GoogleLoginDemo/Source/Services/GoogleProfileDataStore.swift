//
//  GoogleProfileDataStore.swift
//  GoogleLoginDemo
//
//  Created by Иван Барабанщиков on 10/25/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import Foundation
import CoreData

class GoogleProfileDatastore {
    private let stack: CoreDataStack
    let managedContext: NSManagedObjectContext
    private let privateContext: NSManagedObjectContext
    
    convenience init() {
        self.init(CoreDataStack(modelName: "ProfileData"))
    }
    
    init(_ stack: CoreDataStack) {
        self.stack = stack
        managedContext = stack.managedContext
        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedContext
        privateContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Inserting
    func appendProfile(profileInfo: GoogleProfile)  {
        let entity = NSEntityDescription.entity(forEntityName: "GoogleProfile", in: managedContext)!
        if let profile = NSManagedObject(entity: entity, insertInto: managedContext) as? GoogleProfile {
            profile.email = profileInfo.email
            profile.givenName = profileInfo.givenName
            profile.familyName = profileInfo.familyName
            profile.fullName = profileInfo.fullName
            profile.imageURL = profileInfo.imageURL
            profile.idToken = profileInfo.idToken
            profile.userId = profileInfo.userId
            
            stack.saveContext()
        }
    }
    
    // MARK: - Deleting
    func clearAllData() {
        clearObjects(entityName: "GoogleProfile", type: GoogleProfile.self)
    }
    
    private func clearObjects<T>(entityName: String, type: T.Type) where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
        
        do {
            let objects = try (managedContext.fetch(fetchRequest))
            
            for obj in objects {
                managedContext.delete(obj)
            }
            stack.saveContext()
        } catch let error as NSError {
            print("Error \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Fetching
    func fetchProfile() -> GoogleProfile? {
        let fetchRequest: NSFetchRequest<GoogleProfile> = GoogleProfile.fetchRequest()
        
        do {
            let data = try (managedContext.fetch(fetchRequest))
            return data.first
        } catch let error as NSError {
            print("Error \(error), \(error.userInfo)")
        }
        return nil
    }
}
