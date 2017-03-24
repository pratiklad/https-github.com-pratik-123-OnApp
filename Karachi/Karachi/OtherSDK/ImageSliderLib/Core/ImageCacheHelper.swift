//
//  CacheHelper.swift
//  CacheImage
//
//  Created by Anish on 1/6/16.
//  Copyright © 2016 Anish. All rights reserved.
//

import Foundation


class ImageCacheHelper{
    
    static var cache = NSCache<AnyObject, AnyObject>()
    static var isNotRunningDispatch:Bool = true
    
    class  func setObjectForKey(imageData:NSData,imageKey:String){
        
        ImageCacheHelper.cache.setObject(imageData, forKey: imageKey as AnyObject)
        
    }
    
    class  func getObjectForKey(imageKey:String)->NSData?{
        
        return ImageCacheHelper.cache.object(forKey: imageKey as AnyObject) as? NSData
        
    }
    
    class func getImage(imageUrl:String,completionHandler:@escaping (NSData)->()){
        if ImageCacheHelper.isNotRunningDispatch{
            
            ImageCacheHelper.isNotRunningDispatch = false
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    let imgUrl = NSURL(string:imageUrl)
                    let imageData = NSData(contentsOf: imgUrl! as URL)!
                    ImageCacheHelper.setObjectForKey(imageData: imageData,imageKey: "\(imageUrl.hashValue)")
                    ImageCacheHelper.isNotRunningDispatch = true
                    completionHandler(imageData)
                }
            }
            
        }else{
            //  print("alerady started loading image")
            ImageCacheHelper.isNotRunningDispatch = false
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    let imgUrl = NSURL(string:imageUrl)
                    let imageData = NSData(contentsOf: imgUrl! as URL)!
                    ImageCacheHelper.setObjectForKey(imageData: imageData,imageKey: "\(imageUrl.hashValue)")
                    ImageCacheHelper.isNotRunningDispatch = true
                    completionHandler(imageData)}
            }
        }
    }
}
