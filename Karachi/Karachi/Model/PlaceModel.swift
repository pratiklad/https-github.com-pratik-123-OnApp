//
//  PlaceModel.swift
//  Karachi
//
//  Created by Bunty on 18/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit
import CoreData

struct  PlaceModel {
    
    var place_id : String = ""
    var name : String = ""
    var image : String = ""
    var address : String = ""
    var phone : String = ""
    var website : String = ""
    var description : String = ""
    var lat : String = ""
    var lng : String = ""
    var last_update : String = ""
    
    var categoryArray : [CategoryModel] = []
    var imagesArray : [ImageModel] = []
    
    var favorite : Bool = false
    var page : String = ""
    
    var cat_id : String = ""
    
    var distance : Double = 0
    
    init() {
    }
    
    init(place_id : String , name : String , image : String,address : String , phone : String , website : String , description : String , lat : String , lng : String , last_update : String , categoryArray : [CategoryModel] , imagesArray : [ImageModel] , favorite : Bool , page : String , cat_id : String , distance : Double) {
        self.place_id = place_id
        self.name = name
        self.image = image
        self.address = address
        self.phone = phone
        self.website = website
        self.description = description
        self.lat = lat
        self.lng = lng
        self.last_update = last_update
        
        self.categoryArray = categoryArray
        self.imagesArray = imagesArray
        
        self.favorite = favorite
        self.page = page
        self.cat_id = cat_id
        
        self.distance  = distance
    }
    
    mutating func traversServerResponse(array : NSArray , page : String)  -> [PlaceModel] {
        var placeArray : [PlaceModel] = []
        
        for i in 0..<array.count
        {
            guard let dic : NSDictionary = array[i] as? NSDictionary else {
                return placeArray
            }
            
            var place_id : String = ""
            if dic.value(forKey: "place_id") is String
            {
                place_id = dic.value(forKey: "place_id") as! String
            }
            else if dic.value(forKey: "place_id") is NSNumber
            {
                let  p = dic.value(forKey: "place_id") as! NSNumber
                
                place_id = "\(p)"
            }
            
            
            var name : String = ""
            if dic.value(forKey: "name") is String
            {
                name = dic.value(forKey: "name") as! String
            }
            else if dic.value(forKey: "name") is NSNumber
            {
                let  p = dic.value(forKey: "name") as! NSNumber
                
                name = "\(p)"
            }
            
            var image : String = ""
            if dic.value(forKey: "image") is String
            {
                image = dic.value(forKey: "image") as! String
            }
            else if dic.value(forKey: "image") is NSNumber
            {
                let  p = dic.value(forKey: "image") as! NSNumber
                
                image = "\(p)"
            }
            
            var address : String = ""
            if dic.value(forKey: "address") is String
            {
                address = dic.value(forKey: "address") as! String
            }
            else if dic.value(forKey: "address") is NSNumber
            {
                let  p = dic.value(forKey: "address") as! NSNumber
                
                address = "\(p)"
            }
            
            var phone : String = ""
            if dic.value(forKey: "phone") is String
            {
                phone = dic.value(forKey: "phone") as! String
            }
            else if dic.value(forKey: "phone") is NSNumber
            {
                let  p = dic.value(forKey: "phone") as! NSNumber
                
                phone = "\(p)"
            }
            
            var website : String = ""
            if dic.value(forKey: "website") is String
            {
                website = dic.value(forKey: "website") as! String
            }
            else if dic.value(forKey: "website") is NSNumber
            {
                let  p = dic.value(forKey: "website") as! NSNumber
                
                website = "\(p)"
            }
            
            
            var description : String = ""
            if dic.value(forKey: "description") is String
            {
                phone = dic.value(forKey: "description") as! String
            }
            else if dic.value(forKey: "description") is NSNumber
            {
                let  p = dic.value(forKey: "description") as! NSNumber
                
                description = "\(p)"
            }
            
            
            var lat : String = ""
            if dic.value(forKey: "lat") is String
            {
                lat = dic.value(forKey: "lat") as! String
            }
            else if dic.value(forKey: "lat") is NSNumber
            {
                let  p = dic.value(forKey: "lat") as! NSNumber
                
                lat = "\(p)"
            }
            
            var lng : String = ""
            if dic.value(forKey: "lng") is String
            {
                lng = dic.value(forKey: "lng") as! String
            }
            else if dic.value(forKey: "lng") is NSNumber
            {
                let  p = dic.value(forKey: "lng") as! NSNumber
                
                lng = "\(p)"
            }
            
           
            var last_update : String = ""
            if dic.value(forKey: "last_update") is String
            {
                last_update = dic.value(forKey: "last_update") as! String
            }
            else if dic.value(forKey: "last_update") is NSNumber
            {
                let  p = dic.value(forKey: "last_update") as! NSNumber
                
                last_update = "\(p)"
            }
            
            
            var catArray : [CategoryModel] =  []
            guard let catagoryArray =  dic.value(forKey: "categories") as? NSArray else{
                return placeArray
            }
            
            var cat_idValue : [String] = []
            for j in 0..<catagoryArray.count
            {
                guard let recDic : NSDictionary = catagoryArray[j] as? NSDictionary else {
                    return placeArray
                }
                
                var cat_id : String = ""
                if recDic.value(forKey: "last_update") is String
                {
                    cat_id = recDic.value(forKey: "cat_id") as! String
                }
                else if recDic.value(forKey: "cat_id") is NSNumber
                {
                    let  p = recDic.value(forKey: "cat_id") as! NSNumber
                    
                    cat_id = "\(p)"
                }
                
                cat_idValue.append(cat_id)
                
                var name : String = ""
                if recDic.value(forKey: "name") is String
                {
                    name = recDic.value(forKey: "name") as! String
                }
                else if recDic.value(forKey: "name") is NSNumber
                {
                    let  p = recDic.value(forKey: "name") as! NSNumber
                    
                    name = "\(p)"
                }
                
                catArray.append(CategoryModel(cat_id: "\(cat_id)", name: name))
            }
            
            var imgArray : [ImageModel] =  []
            guard let imageArray =  dic.value(forKey: "images") as? NSArray else{
                return placeArray
            }
            for j in 0..<imageArray.count
            {
                guard let recDic : NSDictionary = imageArray[j] as? NSDictionary else {
                    return placeArray
                }
                
                var place_id : String = ""
                if recDic.value(forKey: "place_id") is String
                {
                    place_id = recDic.value(forKey: "place_id") as! String
                }
                else if recDic.value(forKey: "place_id") is NSNumber
                {
                    let  p = recDic.value(forKey: "place_id") as! NSNumber
                    place_id = "\(p)"
                }
                
                
                var name : String = ""
                if recDic.value(forKey: "name") is String
                {
                    name = recDic.value(forKey: "name") as! String
                }
                else if recDic.value(forKey: "name") is NSNumber
                {
                    let  p = recDic.value(forKey: "name") as! NSNumber
                    name = "\(p)"
                }
                
                imgArray.append(ImageModel(place_id: "\(place_id)", name: name.replacingOccurrences(of: " ", with: "%20")))
            }
            
            let distVal =  distanceFilter(lat: lat.doubleValue, long: lng.doubleValue)

            
            placeArray.append(PlaceModel(place_id: "\(place_id)", name: name, image: image.replacingOccurrences(of: " ", with: "%20"), address: address, phone: phone, website: website, description: description, lat: "\(lat)", lng: "\(lng)", last_update: "\(last_update)", categoryArray: catArray, imagesArray: imgArray , favorite : false , page : page , cat_id : cat_idValue.joined(separator: "&&&") , distance : distVal ))
            
            self.insertRecord(page: page, value: dic , place_id : "\(place_id)" , cat_idValue : cat_idValue.joined(separator: "&&&"))
        }
        
        return placeArray
    }
   
    
    //UpdateFavorite List
    func updatefavoriteoriteList(page: String , place_id : String ,favorite : Bool )  {
        
        let context = getDBContext()
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"CategoryPages")
        fetchRequest.predicate = NSPredicate(format: "place_id = %@ && page = %@", place_id , page)
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
                        
                        managedObject.setValue(favorite, forKey: "favorite")
                    }
                    do
                    {
                        try context.save()
                    }
                    catch let error {
                        print("error in update ->\(error.localizedDescription)")
                    }
                }
            }
        }
        catch _ {}
    }
    //==================end update favorite list=============
    
    
    func insertRecord(page:String , value : NSDictionary , place_id : String , cat_idValue : String)
    {
        let context = getDBContext()
        let entity =  NSEntityDescription.entity(forEntityName: "CategoryPages",in:context)
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"CategoryPages")
        fetchRequest.predicate = NSPredicate(format: "place_id = %@ && page = %@", place_id , page)
        
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
                        managedObject.setValue("\(page)", forKey: "page")
                        
                        var  str : String = ""
                        do {
                            let jsonD = try JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted)
                            str = NSString(data: jsonD, encoding: String.Encoding.utf8.rawValue) as! String
                        }
                        catch _ {}
                        
                        managedObject.setValue(str, forKey: "value")
                        managedObject.setValue("\(place_id)", forKey: "place_id")
                    
                        managedObject.setValue(managedObject.value(forKey: "favorite") as! Bool, forKey: "favorite")
                        
                        managedObject.setValue(managedObject.value(forKey: "cat_id") as! String, forKey: "cat_id")

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
                    
                    managedObject.setValue("\(page)", forKey: "page")
                    
                    var  str : String = ""
                    do {
                        let jsonD = try JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted)
                        str = NSString(data: jsonD, encoding: String.Encoding.utf8.rawValue) as! String
                    }
                    catch _ {}
                    
                    
                    managedObject.setValue(str, forKey: "value")
                    
                    managedObject.setValue("\(place_id)", forKey: "place_id")
                    
                    managedObject.setValue(false, forKey: "favorite")
                    
                    managedObject.setValue(cat_idValue , forKey: "cat_id")

                    
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
    
    
    var placeArray : [PlaceModel] = []
    mutating func selectRecord(page: String) -> [PlaceModel] {
        
        placeArray  = []
        let context = getDBContext()
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CategoryPages")
        
        if page != "search"
        {
            let predicate = NSPredicate(format: "page == %@", "\(page)")
            request.predicate = predicate
        }
        do {
            let results = try context.fetch(request)
            for i in 0..<results.count
            {
                let dictionary = results[i] as AnyObject
                
                //                guard let page = dictionary.value(forKey: "page") as? String else {
                //                    print("name get error")
                //                    return
                //                }
                guard let value = dictionary.value(forKey: "value") as? String else {
                    print("name get error")
                    return placeArray
                }
                
                guard let cat_id = dictionary.value(forKey: "cat_id") as? String else {
                    print("name get error")
                    return placeArray
                }
                
                guard let favorite = dictionary.value(forKey: "favorite") as? Bool else {
                    print("name get error")
                    return placeArray
                }
                
                do {
                    let obj : AnyObject = try JSONSerialization.jsonObject(with: value.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    
                    let dic = obj as? NSDictionary
                    //print(dic ?? "nil")
                    
                    self.traversDBSelecectRecord(dic: dic! , favorite : favorite , page:  page , cat_id : cat_id)
                    
                }
                catch _ {}
            }
            
            return placeArray
            
        } catch {
            print("Error with request: \(error)")
            return placeArray
        }
    }
    
    mutating func selectFavouriteRecord() -> [PlaceModel] {
        
        placeArray  = []
        let context = getDBContext()
        
        let predicate = NSPredicate(format: "favorite == %@", NSNumber(booleanLiteral: true))
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CategoryPages")
        request.predicate = predicate
        
        do {
            let results = try context.fetch(request)
            for i in 0..<results.count
            {
                let dictionary = results[i] as AnyObject
                
                //                guard let page = dictionary.value(forKey: "page") as? String else {
                //                    print("name get error")
                //                    return
                //                }
                
                guard let pageVal = dictionary.value(forKey: "page") as? String else {
                    print("page get error")
                    return placeArray
                }
                
                guard let value = dictionary.value(forKey: "value") as? String else {
                    print("name get error")
                    return placeArray
                }
                
                guard let favorite = dictionary.value(forKey: "favorite") as? Bool else {
                    print("name get error")
                    return placeArray
                }
                
                guard let cat_id = dictionary.value(forKey: "cat_id") as? String else {
                    print("name get error")
                    return placeArray
                }
                
                do {
                    let obj : AnyObject = try JSONSerialization.jsonObject(with: value.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    
                    let dic = obj as? NSDictionary
                    //print(dic ?? "nil")
                    
                    self.traversDBSelecectRecord(dic: dic! , favorite : favorite , page:  pageVal , cat_id : cat_id)
                    
                }
                catch _ {}
            }
            
            return placeArray
            
        } catch {
            print("Error with request: \(error)")
            return placeArray
        }
    }
    
    
    mutating func traversDBSelecectRecord(dic : NSDictionary , favorite : Bool , page : String , cat_id : String)  {
        
        guard let place_id : Int = dic.value(forKey: "place_id") as? Int  else {
            return
        }
        guard let name : String = dic.value(forKey: "name") as? String  else {
            return
        }
        guard let image : String = dic.value(forKey: "image") as? String  else {
            return
        }
        guard let address : String = dic.value(forKey: "address") as? String  else {
            return
        }
        
        var phone : String = ""
        if dic.value(forKey: "phone") is String
        {
            phone = dic.value(forKey: "phone") as! String
        }
        else if dic.value(forKey: "phone") is NSNumber
        {
            let  p = dic.value(forKey: "phone") as! NSNumber
            
            phone = "\(p)"
        }
        
        var website : String = ""
        if dic.value(forKey: "website") is String
        {
            website = dic.value(forKey: "website") as! String
        }
        else if dic.value(forKey: "website") is NSNumber
        {
            let  p = dic.value(forKey: "website") as! NSNumber
            
            website = "\(p)"
        }
        
        guard let description : String = dic.value(forKey: "description") as? String  else {
            return
        }
        guard let lat : NSNumber = dic.value(forKey: "lat") as? NSNumber  else {
            return
        }
        guard let lng : NSNumber = dic.value(forKey: "lng") as? NSNumber  else {
            return
        }
        guard let last_update : NSNumber = dic.value(forKey: "last_update") as? NSNumber  else {
            return
        }
        
        var catArray : [CategoryModel] =  []
        guard let catagoryArray =  dic.value(forKey: "categories") as? NSArray else{
            return
        }
        for j in 0..<catagoryArray.count
        {
            guard let recDic : NSDictionary = catagoryArray[j] as? NSDictionary else {
                return
            }
            
            guard let cat_id : Int = recDic.value(forKey: "cat_id") as? Int  else {
                return
            }
            
            guard let name : String = recDic.value(forKey: "name") as? String  else {
                return
            }
            catArray.append(CategoryModel(cat_id: "\(cat_id)", name: name))
        }
        
        var imgArray : [ImageModel] =  []
        guard let imageArray =  dic.value(forKey: "images") as? NSArray else{
            return
        }
        for j in 0..<imageArray.count
        {
            guard let recDic : NSDictionary = imageArray[j] as? NSDictionary else {
                return
            }
            
            guard let place_id : Int = recDic.value(forKey: "place_id") as? Int  else {
                return
            }
            
            guard let name : String = recDic.value(forKey: "name") as? String  else {
                return
            }
            imgArray.append(ImageModel(place_id: "\(place_id)", name: name.replacingOccurrences(of: " ", with: "%20")))
        }
        
        let distVal =  distanceFilter(lat: lat.doubleValue, long: lng.doubleValue)

        placeArray.append(PlaceModel(place_id: "\(place_id)", name: name, image: image.replacingOccurrences(of: " ", with: "%20"), address: address, phone: phone, website: website, description: description, lat: "\(lat)", lng: "\(lng)", last_update: "\(last_update)", categoryArray: catArray, imagesArray: imgArray , favorite : favorite , page: page , cat_id : cat_id , distance : distVal))
    }

    
}

struct CategoryModel {
    
    var cat_id : String = ""
    var name : String = ""
    
    init() {
    }
    
    init(cat_id : String , name : String) {
        self.cat_id = cat_id
        self.name = name
    }
}

struct ImageModel {
    
    var place_id : String = ""
    var name : String = ""
    
    init() {
    }
    
    init(place_id : String , name : String) {
        self.place_id = place_id
        self.name = name
    }
}



