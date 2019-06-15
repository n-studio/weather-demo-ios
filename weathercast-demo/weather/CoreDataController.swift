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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        do {
            try managedContext.save()
        } catch let error {
            NSLog("Error: \(error.localizedDescription)")
        }
    }
}
