//
//  DataController.swift
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 16.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

import Foundation

private let cEntryName = "CEntry"
private let cFeedName = "CFeed"

class DataController {
    
    func getEntries() -> [AnyObject] {
        var request = NSFetchRequest(entityName: cEntryName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        if let entries = self.managedObjectContext?.executeFetchRequest(request, error: nil) {
            return entries
        }
        
        return []
    }
    
    func getFeedData() -> (String?, String?) {
        var feedRequest = NSFetchRequest(entityName: cFeedName)
        
        if let items = self.managedObjectContext?.executeFetchRequest(feedRequest, error: nil) {
            if let feedHeader = items.first as? CFeed {
                return (feedHeader.name?, feedHeader.theDescription?)
            }
        }
        return ("-", "-")
    }
    
    func cacheFeed( feed:Feed, completion:()->() ) {
        
        let coordinator = self.persistentStoreCoordinator
        var context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.managedObjectContext
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            var feedRequest = NSFetchRequest(entityName: cFeedName)
            if let items = context.executeFetchRequest(feedRequest, error: nil) {
                if let feedHeader = items.first as? CFeed {
                    feedHeader.theDescription = feed.theDescription
                    feedHeader.name = feed.name
                } else {
                    let newFeed = NSEntityDescription.insertNewObjectForEntityForName(cFeedName, inManagedObjectContext: context) as CFeed
                    newFeed.theDescription = feed.theDescription
                    newFeed.name = feed.name
                }
            }
            
            var request = NSFetchRequest(entityName: cEntryName)
            request.includesPropertyValues = false
            
            if let entries = context.executeFetchRequest(request, error: nil) {
                
                for entry in entries {
                    context.deleteObject(entry as NSManagedObject)
                }
            }
            
            let dateFormatter = Rfc3339DateFormatter()
            
            for feedEntity in feed.entries {
                var newEntity:CEntry = NSEntityDescription.insertNewObjectForEntityForName(cEntryName, inManagedObjectContext: context) as CEntry
                
                newEntity.theId = feedEntity.theId
                newEntity.body = feedEntity.body
                newEntity.date = dateFormatter.dateFromRfc3339(feedEntity.date)

                if let via = feedEntity.via? {
                    newEntity.viaName = via.name
                }
                if let from = feedEntity.from? {
                    newEntity.fromName = from.name
                }
            }
            
            context.save(nil)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.saveContext()
                completion()
            }
        }
        
    }
    
    // MARK: - CoreData
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("RealLifeApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("RealLifeApp.sqlite")
        println("Store: \(url)")
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "com.epam.RealApp", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {

        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
}