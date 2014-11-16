//
//  AppEngine.swift
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 09.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

import Foundation
import CoreData

class AppController {

    let friendfeed: FriendFeedService
    let dataController: DataController
    
    let currentFeed: Feed?
    
    let dataReadySlot: SignalSlot<[AnyObject]>
    let feedReadySlot: SignalSlot<(String?, String?)>
    
    init( dataController:DataController, friendfeed: FriendFeedService ) {
        self.friendfeed = friendfeed
        self.dataController = dataController
        
        self.dataReadySlot = SignalSlot<[AnyObject]>()
        self.feedReadySlot = SignalSlot<(String?, String?)>()
    }
    
    func startupSequence() {
        self.fireDataReady()
        self.updateFeed()
    }
    
    private func fireDataReady() {
        let feedData = self.dataController.getFeedData()
        self.feedReadySlot.fire(feedData)
        let entries = self.dataController.getEntries()
        self.dataReadySlot.fire(entries)
    }
    
    private func updateFeed() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            self.friendfeed.feedWithCompletion { (feed, error) in
                if let err = error {
                   println("Feed getting error: \(error)")
                } else if let realFeed = feed {
                    
                    self.dataController.cacheFeed( realFeed ) {
                        self.fireDataReady()
                    }
                }
            }
        }
    }
    
}