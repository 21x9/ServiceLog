//
//  Maintenance.h
//  ServiceLog
//
//  Created by Mark Adams on 1/17/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Car;

@interface Maintenance : NSManagedObject

@property (nonatomic, retain) NSDate * datePerformed;
@property (nonatomic, retain) NSNumber * mileage;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * sectionIdentifier;
@property (nonatomic, retain) Car *car;

@end
