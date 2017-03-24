//
//  ServerCommunication.swift
//  Demo
//
//  Created by Bunty on 13/02/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

//MARK: Server GET POST Method
/*========================================================================
 * Function Name: SendServerRequest
 * Function Purpose: send to server get and post method for retrive data
 * CreateByAndDate :add by Bunty 18-02-2017
 * =====================================================================*/
func SendServerRequest(type:String,baseURL:String,param:AnyObject, requestCompleted:@escaping (_ suceeded:Bool,_ msg:String,_ result: AnyObject) -> ()) -> Void  {
    
    let manager = AFHTTPSessionManager()
    manager.requestSerializer = AFHTTPRequestSerializer()
    manager.responseSerializer = AFHTTPResponseSerializer()
    
    print("\(type) method->\(baseURL) \nparam->\(param)")
    
    if type == "GET"
    {
        manager.get("\(baseURL)",
            parameters: nil, progress:nil,
            success: {
                
                operation, responseObject in
                var json :AnyObject!
                
                if (responseObject) != nil
                {
                    json = (try! JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as AnyObject
                    
                    print("GetMethod ->\(json!)")
                    
                    requestCompleted(true, "", json!)
                }
                else
                {
                    requestCompleted(false, "Error: Json not retrieve properly" , "" as AnyObject)
                }
        },
            failure: {
                operation, error in
                print("Error: " + error.localizedDescription)
                
                requestCompleted(false, "Error: " + error.localizedDescription , "" as AnyObject as AnyObject)
                
        })
    }
    else
    {
        
        manager.post("\(baseURL)",
            
            parameters: param, progress:nil,
            success: {
                operation, responseObject in
                var json :AnyObject!
                
                if (responseObject) != nil
                {
                    json = (try! JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as AnyObject
                    
                    print("post method ->\(json!)")
                    
                    requestCompleted(true, "", json!)
                }
                else
                {
                    requestCompleted(false, "Error: Json not retrieve properly" , "" as AnyObject)
                }
        },
            failure: {
                operation, error in
                print("Error: " + error.localizedDescription)
                
                requestCompleted(false, "Error: " + error.localizedDescription , "" as AnyObject)
        })
    }
}
//============end SendServerRequest method===========================================
