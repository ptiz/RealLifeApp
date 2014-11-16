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
    
    let dataReadySlot: SignalSlot<Feed>
    
    init( dataController:DataController, friendfeed: FriendFeedService ) {
        self.friendfeed = friendfeed
        self.dataController = dataController
        
        self.dataReadySlot = SignalSlot<Feed>()
    }
    
    func startupSequence() {
        self.updateFeed()
    }
        
    private func updateFeed() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            self.friendfeed.feedWithCompletion { (feed, error) in
                if let err = error {
                   println("Feed getting error: \(error)")
                } else if let realFeed = feed {
                    self.dataReadySlot.fire(realFeed)
                }
            }
        }
    }
    
}