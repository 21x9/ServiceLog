//
//  Car.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/23/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Maintenance;

@interface Car : NSManagedObject

@property (nonatomic, retain) NSData * fullImage;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * vin;
@property (nonatomic, retain) NSString * lugNutTorque;
@property (nonatomic, retain) NSString * bracketTorque;
@property (nonatomic, retain) NSString * knuckleTorque;
@property (nonatomic, retain) NSSet *maintenanceEvents;
@end

@interface Car (CoreDataGeneratedAccessors)

- (void)addMaintenanceEventsObject:(Maintenance *)value;
- (void)removeMaintenanceEventsObject:(Maintenance *)value;
- (void)addMaintenanceEvents:(NSSet *)values;
- (void)removeMaintenanceEvents:(NSSet *)values;

@end
