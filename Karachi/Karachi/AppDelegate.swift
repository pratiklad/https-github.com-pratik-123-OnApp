//
//  AppDelegate.swift
//  Karachi
//
//  Created by Bunty on 17/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let frosetedMenu : REFrostedViewController = REFrostedViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        menu()
        
        
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print("path->\(paths[0])")
        

        
        return true
    }
    
    //MARK: Menu Setting
    func menu() {
        
        GMSServices.provideAPIKey("AIzaSyDS28a35OMMv-6ZmOM-bj7sPHRqG2ULJT4")

        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let dashBoard : DashBoardVC = storyboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
        
        let nav = UINavigationController(rootViewController: dashBoard)
        
        let menu = storyboard.instantiateViewController(withIdentifier: "MenuVC" ) as! MenuVC
        
        menu.dashBoard = dashBoard
        
        frosetedMenu.contentViewController = nav
        frosetedMenu.menuViewController = menu
        frosetedMenu.menuViewSize = CGSize(width: UIScreen.main.bounds.size.width - 100, height: UIScreen.main.bounds.size.height)
        
        frosetedMenu.liveBlurBackgroundStyle = .light
        frosetedMenu.blurRadius = 0
        
        self.window?.rootViewController = frosetedMenu
        
        // status bar set with differnt color in view controler
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        view.tag = 1000000
        view.backgroundColor = getNavigationBarColor()
        self.window!.rootViewController!.view.addSubview(view)
        
    }
    //===========end menu setting========
    
    func resetNavigationColor()  {
        
        guard let v = self.window?.rootViewController?.view.viewWithTag(1000000) else {
            return
        }
        v.backgroundColor = getNavigationBarColor()
    }
    
    //MARK: MenuDrawwerSetting
    func openMenu(controller : UIViewController)  {
        controller.frostedViewController.presentMenuViewController()
    }
    
    //MARK: MenuClose
    func closeMenu()  {
        frosetedMenu.hideMenuViewController(completionHandler: nil)
    }
    //========end menu close===
    
   
    // MARK: - Core Data stack
    //MARK: ios 10.* > CoreData Code
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Karachi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            let contaxt = managedObjectContext
            if contaxt.hasChanges
            {
                do {
                    try contaxt.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
        }
    }
    //MARK: ios 10.* > CoreData Code END
    
    //MARK: ios 9 < Core Data Code ========================
    //MARK: Core data method===============
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mindlogic.app.WorkAssignment" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Karachi", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true]
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    //MARK: End iOS < 9 Core Data code ====================
    
}

