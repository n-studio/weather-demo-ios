//
//  CoreDataController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataController: DatabaseController {
    static var shared = CoreDataController()
    typealias ForecastResult = ([ForecastModel], Error?) -> ()

    func fetchIncomingForecasts(city: String, from: Date, type: String, completion: @escaping ForecastResult) {
        let predicate = NSPredicate(format: "date >= %@ AND cityIdentifier ==[c] %@ AND type == %@", argumentArray: [from, city, type])
        fetchForecasts(predicate: predicate, completion: completion)
    }

    func fetchForecasts(predicate: NSPredicate, completion: @escaping ForecastResult) {
        persistentContainer.performBackgroundTask() { context in
            let fetchRequest : NSFetchRequest<Forecast> = Forecast.fetchRequest()
            fetchRequest.predicate = predicate
            let sort = NSSortDescriptor(key: #keyPath(Forecast.date), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            do {
                let forecasts = try context.fetch(fetchRequest)
                completion(forecasts, nil)
            } catch {
                completion([], error)
            }
        }
    }

    func cleanForecasts(city: String, completion: @escaping () -> ()) {
        persistentContainer.performBackgroundTask() { context in
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
            self.save(withContext: context)
            completion()
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "weathercast_demo")
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func save(withContext context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
