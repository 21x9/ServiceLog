//
//  Car+Helpers.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/14/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "Car+Helpers.h"

@implementation Car (Helpers)

+ (Car *)carWithMake:(NSString *)make model:(NSString *)model year:(NSNumber *)year managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Car *newCar = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
    newCar.make = make;
    newCar.model = model;
    newCar.year = year;
    
    return newCar;
}

- (NSString *)makeAndModel
{
    return [NSString stringWithFormat:@"%@ %@", self.make, self.model];
}

@end
