//
//  CommonVariable.swift
//  Karachi
//
//  Created by Bunty on 17/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit
import CoreData

let preference = UserDefaults.standard

let appDelegateObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate

let appName = "Karachi on App"


let baseURL : String = "http://karachi.onapp.city/app/services"
let baseImageURLPath = "http://karachi.onapp.city/uploads/place/"


let UniqID : String = UIDevice.current.identifierForVendor!.uuidString

let getAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"
let getAppBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "0"


let deviceOS = "IOS"
let deviceDate = Date()


var menuCategory : [CategoryMenuModel] = []


var isFirstDataLoad : Bool = false

var curLat:Double = 0
var curLong:Double = 0


var total_Load_Count : Int = 0
var count_total : Int = 0
var pageIndex : Int = 1

var isFirstMenuLoad : Bool = false
/*========================================================================
 * Function Name: getDeviceToken
 * Function Purpose: device token get from server
 * CreateByAndDate : add by bunty 23-11-2016
 * =====================================================================*/
func getDeviceToken() -> String
{
    var token:String = "0"
    if preference.value(forKey: "deviceToken") != nil
    {
        token = preference.value(forKey: "deviceToken") as! String
    }
    return token
}
//==================end getDeviceToken method=================


func getDBContext() -> NSManagedObjectContext{
    var managedContext  : NSManagedObjectContext!
    if #available(iOS 10.0, *) {
        managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    else
    {
        managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    }
    return managedContext
}

let colorName : [String] = ["Default" , "Red" , "Pink" , "Purple" , "Deep Purple" , "Indigo" , "Blue" , "Light Blue", "Cyan" , "Teal" , "Green" ,"Orange" , "Deep Orange" , "Brown" , "Blue Grey" ]


func getNavigationBarColorCode(index : Int) -> UIColor {
    
    switch index {
    case 0:
        return UIColor(red:86/255.0, green:138/255.0 ,blue:183/255.0 ,alpha:1.0)
    case 1 :
        return UIColor(red:244/255.0, green:67/255.0 ,blue:54/255.0 ,alpha:1.0)
    case 2 :
        return UIColor(red:236/255.0, green:64/255.0 ,blue:122/255.0 ,alpha:1.0)
    case 3 :
        return UIColor(red:156/255.0, green:39/255.0 ,blue:176/255.0 ,alpha:1.0)
    case 4 :
        return UIColor(red:103/255.0, green:58/255.0 ,blue:183/255.0 ,alpha:1.0)
    case 5 :
        return UIColor(red:63/255.0, green:81/255.0 ,blue:181/255.0 ,alpha:1.0)
    case 6 :
        return UIColor(red:33/255.0, green:150/255.0 ,blue:243/255.0 ,alpha:1.0)
    case 7 :
        return UIColor(red:3/255.0, green:169/255.0 ,blue:244/255.0 ,alpha:1.0)
    case 8 :
        return UIColor(red:0/255.0, green:188/255.0 ,blue:212/255.0 ,alpha:1.0)
    case 9 :
        return UIColor(red:0/255.0, green:150/255.0 ,blue:136/255.0 ,alpha:1.0)
    case 10 :
        return UIColor(red:76/255.0, green:175/255.0 ,blue:80/255.0 ,alpha:1.0)

    case 11 :
        return UIColor(red:255/255.0, green:152/255.0 ,blue:0/255.0 ,alpha:1.0)

    case 12 :
        return UIColor(red:255/255.0, green:87/255.0 ,blue:34/255.0 ,alpha:1.0)

    case 13 :
        return UIColor(red:121/255.0, green:85/255.0 ,blue:72/255.0 ,alpha:1.0)

    case 14 :
        return UIColor(red:96/255.0, green:125/255.0 ,blue:139/255.0 ,alpha:1.0)

    default:
        return UIColor(red:86/255.0, green:138/255.0 ,blue:183/255.0 ,alpha:1.0)
    }
}
