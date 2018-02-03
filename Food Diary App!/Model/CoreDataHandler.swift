//
//  CoreDataHandler.swift
//  Food Diary App!
//
//  Created by Ben Shih on 30/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHandler
{
    // General Variables
    private var fileName: [String] = [] // Storing the names of the images
    private var notes: [String] = [] // Storing notes
    
    // Nutrition Info Variables
    private var dairyList: [Int] = []
    private var vegetableList: [Int] = []
    private var proteinList: [Int] = []
    private var fruitList: [Int] = []
    private var grainList: [Int] = []
    private let request: NSFetchRequest<NSFetchRequestResult>
    private let context: NSManagedObjectContext
    
    init()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
        request.returnsObjectsAsFaults = false
    }
    
    mutating func getImageFilename() -> [String]
    {
        fileName.removeAll()
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    // Store data in the corresponding array
                    if let imageName = result.value(forKey: "imageName") as? String
                    {
                        fileName.append(imageName)
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        return fileName
    }
    
    mutating func getImageFilename(type: String) -> [String]
    {
        let queryFor = type
        fileName.removeAll()
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let queryElement = result.value(forKey: queryFor) as? Int
                    {
                        // Store data in the corresponding array
                        if queryElement != 0
                        {
                            if let imageName = result.value(forKey: "imageName") as? String
                            {
                                fileName.append(imageName)
                            }
                        }
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        return fileName
    }
    
    mutating func get5nList() -> [String:[Int]]
    {
        grainList.removeAll()
        vegetableList.removeAll()
        fruitList.removeAll()
        proteinList.removeAll()
        dairyList.removeAll()
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let imageName = result.value(forKey: "imageName") as? String
                    {
                        // Store data in the corresponding array
                        if let grain_value = result.value(forKey: "n_Grain") as? Int
                        {
                            if let vegetableValue = result.value(forKey: "n_Vegetable") as? Int
                            {
                                if let fruitValue = result.value(forKey: "n_Fruit") as? Int
                                {
                                    if let dairyValue = result.value(forKey: "n_Dairy") as? Int
                                    {
                                        if let proteinValue = result.value(forKey: "n_Protein") as? Int
                                        {
                                            self.grainList.append(grain_value)
                                            self.vegetableList.append(vegetableValue)
                                            self.proteinList.append(proteinValue)
                                            self.dairyList.append(dairyValue)
                                            self.fruitList.append(fruitValue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            print ("grain list \(grainList)")
        }catch
        {
            print("Retrieving core data error")
        }
        return ["grainList":grainList,"vegetableList":vegetableList,"proteinList":proteinList,"dairyList":dairyList,"fruitList":fruitList]
    }
    
    mutating func getNote() -> [String]
    {
        notes.removeAll()
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    // Store data in the corresponding array
                    if let note = result.value(forKey: "note") as? String
                    {
                        notes.append(note)
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        return notes
    }
}
