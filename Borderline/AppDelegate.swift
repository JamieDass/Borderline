//
//  AppDelegate.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-20.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    private let fontName = "Arvo"
//    private var scaledFont: ScaledFont = {
//        return ScaledFont(fontName: fontName)
//    }()
    var window: UIWindow?
//    let defaultBlue = UIColor(red: 11/255, green: 24/255, blue: 37/255, alpha: 1.0)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barStyle = .blackOpaque
//        UINavigationBar.appearance().tintColor = GlobalConstants.defaultBlue
            UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().isOpaque = true
//        UINavigationBar.appearance().barTintColor = UIColor.orange
        UINavigationBar.appearance().barTintColor = GlobalConstants.darkBlue
        let scaledFont : ScaledFont = ScaledFont(fontName: "Arvo")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : scaledFont.font(forTextStyle: UIFontTextStyle.title1)
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : scaledFont.font(forTextStyle: UIFontTextStyle.title3),
                NSAttributedStringKey.foregroundColor : UIColor.white,
                ], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : scaledFont.font(forTextStyle: UIFontTextStyle.title3),
                NSAttributedStringKey.foregroundColor : UIColor.white,
                ], for: .highlighted)
//        setStatusBarBackgroundColor(UIColor.clear)
        
//        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(2, forBarMetrics: UIBarMetrics.Default)
//        [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]]
        
        
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "score") == nil)
        {
            print("creating score default")
            defaults.set(0, forKey: "score")
        }
        if (defaults.object(forKey: "sounds") == nil)
        {
            print("creating sound bool")
            defaults.set(true, forKey: "sounds")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Jetliner.Borderline" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Borderline", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("BorderlineCountries.sqlite")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            let sourceSqliteURLs = [Bundle.main.url(forResource: "BorderlineCountries", withExtension: "sqlite")!, Bundle.main.url(forResource: "BorderlineCountries", withExtension: "sqlite-wal")!, Bundle.main.url(forResource: "BorderlineCountries", withExtension: "sqlite-shm")!]
            
            let destSqliteURLs = [self.applicationDocumentsDirectory.appendingPathComponent("BorderlineCountries.sqlite"),
                                  self.applicationDocumentsDirectory.appendingPathComponent("BorderlineCountries.sqlite-wal"),
                                  self.applicationDocumentsDirectory.appendingPathComponent("BorderlineCountries.sqlite-shm")]
            
            var error:NSError? = nil
            var index = 0
            for url in sourceSqliteURLs{
                do {
                    try FileManager.default.copyItem(at: url, to: destSqliteURLs[index])
                }catch {
                    print(error)
                }
                index+=1
            }            
        }
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
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

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    
    func setStatusBarBackgroundColor(_ color: UIColor) {
        
        guard  let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else {
            return
        }
        
        statusBar.backgroundColor = color
    }
    
}

