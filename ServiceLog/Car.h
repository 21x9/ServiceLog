//
//  Car.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/10/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Car : NSManagedObject

@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;

@end
