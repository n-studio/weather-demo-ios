//
//  CoreDataController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController {
    static let shared = CoreDataController()
    typealias ForecastResult = ([Forecast], Error?) -> ()

    func fetchIncomingForecasts(city: String, from: Date, completion: @escaping ForecastResult) {
        let predicate = NSPredicate(format: "date >= %@ AND cityIdentifier ==[c] %@", argumentArray: [from, city])
        fetchForecasts(predicate: predicate, completion: completion)
    }

    func fetchForecasts(predicate: NSPredicate, completion: @escaping ForecastResult) {
        let context = persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Forecast> = Forecast.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let forecasts = try context.fetch(fetchRequest)
            completion(forecasts, nil)
        } catch {
            completion([], error)
        }
    }

    func cleanForecasts(city: String, completion: @escaping () -> ()) {
        let context = persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let predicate = NSPredicate(format: "cityIdentifier ==[c] %@", argumentArray: [city])
        fetchRequest.predicate = predicate
        do {
            let forecasts = try context.fetch(fetchRequest)
            for forecast in forecasts {
                context.delete(forecast)
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        completion()
    }

    func save() {
        let managedContext = persistentContainer.viewContext

        do {
            try managedContext.save()
        } catch let error {
            NSLog("Error: \(error.localizedDescription)")
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "weathercast_demo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
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
