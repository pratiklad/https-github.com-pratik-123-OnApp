//
//  CommonFuction.swift
//  Karachi
//
//  Created by Bunty on 17/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit


func getNavigationBarColor() -> UIColor {

    let navColor =  preference.integer(forKey: "navColor")
    return getNavigationBarColorCode(index : navColor)
    
}


//Alert display custom funtion
func displayAlert(fromController controller: UIViewController , msg :String) {
    let alertController = UIAlertController(title: appName  , message:  msg, preferredStyle:UIAlertControllerStyle.alert)
    
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
    { action -> Void in
        // Put your code here
    })
    controller.present(alertController, animated: true, completion: nil)
}


extension String {
    // MARK: Base64 encode
    func base64Encode() -> String?  {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    // MARK: Base64 decode
    func base64Decode() -> String? {
        
        let data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        // Convert back to a string
        let base64Decoded = NSString(data: data as! Data, encoding: String.Encoding.utf8.rawValue)
        
        return base64Decoded as String?
    }
}


func convertToDictionary(text: String) -> AnyObject? {
    
    if let data = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: text)) {
        
        return data as AnyObject?
    }
    return nil
}

func distanceFilter(lat : Double , long : Double)  -> Double{
    
    if  curLat == 0.0 && curLong == 0.0
    {
        return 0
    }
    
    let coordinate₀ = CLLocation(latitude: curLat, longitude: curLong)
    let coordinate₁ = CLLocation(latitude: lat, longitude: long)
    
    let distanceInMeters = coordinate₀.distance(from: coordinate₁)
    let km = (distanceInMeters / 1000).roundTo(places: 2)
    
    return km
}


func getDistance(lat : Double , long : Double)  -> String{

    if  curLat == 0.0 && curLong == 0.0
    {
        return ""
    }
    
    let coordinate₀ = CLLocation(latitude: curLat, longitude: curLong)
    let coordinate₁ = CLLocation(latitude: lat, longitude: long)
    
    let distanceInMeters = coordinate₀.distance(from: coordinate₁)
    let km = (distanceInMeters / 1000).roundTo(places: 2)
    
    return "\(km) Km"
}
