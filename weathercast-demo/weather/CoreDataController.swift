//
//  CoreDataController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class CoreDataController {
    func save() {
        var appDelegate: AppDelegate?
        DispatchQueue.main.sync {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
        }
        guard let delegate = appDelegate else { fatalError("Error: Couldn't access appDelegate") }

        let managedContext = delegate.persistentContainer.viewContext

        do {
            try managedContext.save()
        } catch let error {
            NSLog("Error: \(error.localizedDescription)")
        }
    }
}
