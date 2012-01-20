//
//  Car.h
//  ServiceLog
//
//  Created by Mark Adams on 1/18/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Maintenance;

@interface Car : NSManagedObject

@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSData * fullImage;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSSet *maintenanceEvents;
@end

@interface Car (CoreDataGeneratedAccessors)

- (void)addMaintenanceEventsObject:(Maintenance *)value;
- (void)removeMaintenanceEventsObject:(Maintenance *)value;
- (void)addMaintenanceEvents:(NSSet *)values;
- (void)removeMaintenanceEvents:(NSSet *)values;

@end
