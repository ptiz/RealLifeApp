//
//  Entity.h
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 15.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CEntry : NSManagedObject

@property (nonatomic) NSString * body;
@property (nonatomic) NSDate * date;
@property (nonatomic) NSString * fromName;
@property (nonatomic) NSString * viaName;
@property (nonatomic) NSString * theId;

@end
