//
//  CFeed.swift
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 16.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

import Foundation
import CoreData

@objc(CFeed)
class CFeed:NSManagedObject {
    
    @NSManaged var name: NSString?
    @NSManaged var theDescription: NSString?
    
}