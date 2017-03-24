//
//  CategoryModel.swift
//  Karachi
//
//  Created by Bunty on 18/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

import CoreData

struct CategoryMenuModel {

    var cat_id : String = ""
    var name : String = ""
    var icon : String = ""
    
    init() {
    }
    
    init(cat_id : String , name : String , icon : String) {
        self.cat_id = cat_id
        self.name = name
        self.icon = icon
    }
    
    
    mutating func traversServerResponse(array : NSArray){

        var tempArray : [CategoryMenuModel] = []
        for i in 0..<array.count
        {
            guard let dic : NSDictionary = array[i] as? NSDictionary else {
                return
            }
            
            var cat_id : String = ""
            if dic.value(forKey: "cat_id") is Int
            {
                let id = dic.value(forKey: "cat_id") as! Int
                cat_id = "\(id)"
            }
            else if dic.value(forKey: "cat_id") is String
            {
                let id = dic.value(forKey: "cat_id") as! String
                cat_id = "\(id)"
            }
            
           
            var name : String = ""
            if dic.value(forKey: "name") is Int
            {
                let id = dic.value(forKey: "name") as! Int
                name = "\(id)"
            }
            else if dic.value(forKey: "name") is String
            {
                let id = dic.value(forKey: "name") as! String
                name = "\(id)"
            }
            
            var icon : String = ""
            if dic.value(forKey: "icon") is Int
            {
                let id = dic.value(forKey: "icon") as! Int
                icon = "\(id)"
            }
            else if dic.value(forKey: "icon") is String
            {
                let id = dic.value(forKey: "icon") as! String
                icon = "\(id)"
            }
            
            tempArray.append(CategoryMenuModel(cat_id: cat_id, name: name, icon: icon.replacingOccurrences(of: " ", with: "%20")))

            self.insertRecord(cat_id: cat_id, icon: icon, name: name)

        }
        menuCategory = tempArray
    }
    
    
    func insertRecord(cat_id:String , icon : String , name : String) {
        let context = getDBContext()
        let entity =  NSEntityDescription.entity(forEntityName: "MenuList",in:context)
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"MenuList")
        fetchRequest.predicate = NSPredicate(format: "cat_id = %@", cat_id)
        
        do
        {
            let fetchedResults =  try context.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults
            {
                if results.count > 0
                {
                    //print(results.count)
                    for i in 0..<results.count
                    {
                        let managedObject = results[i]
                        // print("i value update ->\(i)")
                        managedObject.setValue("\(cat_id)", forKey: "cat_id")
                        managedObject.setValue("\(icon)", forKey: "icon")
                        managedObject.setValue("\(name)", forKey: "name")
                    }
                    
                    do
                    {
                        try context.save()
                    }
                    catch let error {
                        print("error in update ->\(error.localizedDescription)")
                    }
                }
                else
                {
                    let managedObject = NSManagedObject(entity: entity!,insertInto:context)
                    
                    managedObject.setValue("\(cat_id)", forKey: "cat_id")
                    managedObject.setValue("\(icon)", forKey: "icon")
                    managedObject.setValue("\(name)", forKey: "name")
                    
                    do {
                        try context.save()
                        //  print("succedd...")
                    } catch _ {
                        print("failed to insert ...")
                    }
                }
            }
        }
        catch _ {}
    }
    
    
    
    func selectRecord(){
        
        let context = getDBContext()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MenuList")
        
        do {
            let results = try context.fetch(request)
            
            var tempArray : [CategoryMenuModel] = []

            for i in 0..<results.count
            {
                let dictionary = results[i] as AnyObject
                
                guard let name = dictionary.value(forKey: "name") as? String else {
                    print("name get error")
                    return
                }
                guard let cat_id = dictionary.value(forKey: "cat_id") as? String else {
                    print("name get error")
                    return
                }
                guard let icon = dictionary.value(forKey: "icon") as? String else {
                    print("name get error")
                    return
                }

                tempArray.append(CategoryMenuModel(cat_id: cat_id, name: name, icon: icon.replacingOccurrences(of: " ", with: "%20")))
            }
            menuCategory = tempArray
        } catch {
            
            print("Error with request: \(error)")
        }
    }
    
}
