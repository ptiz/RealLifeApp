//
//  AppDelegate.swift
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 09.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        
    lazy var friendFeed: FriendFeedService = {
        return FriendFeedService()
    }()
    
    lazy var appController: AppController = {
        return AppController( friendfeed: self.friendFeed)
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let viewController = window?.rootViewController as ViewController
        
        self.appController.dataReadySlot <+> (NSStringFromClass(viewController.dynamicType), viewController.updateData)
        
        self.appController.startupSequence()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
    }
 
}

