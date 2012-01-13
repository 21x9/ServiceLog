//
//  Maintenance.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/13/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Maintenance : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSDate * datePerformed;
@property (nonatomic, retain) NSNumber * mileage;

@end
