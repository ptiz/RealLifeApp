//
//  FriendFeedService.swift
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 13.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

import Foundation

class FriendFeedService {
    
    private let transport: IFHTTPTransport
    private let friendfeed:Friendfeed
    
    init() {
        transport = IFHTTPTransport(URL:NSURL(string:"http://friendfeed-api.com/v2"))
        friendfeed = Friendfeed(transport:transport)
    }
    
    func feedWithCompletion( completion:(feed:Feed?, error: NSError?) -> Void ) -> Void {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            var error:NSError?
            let feed = self.friendfeed.getFeedWithPrefix("feed/bret/friends", andError:&error)
            
            dispatch_async(dispatch_get_main_queue(), {
                completion(feed: feed, error: error)
            });
        })
    }
    
}