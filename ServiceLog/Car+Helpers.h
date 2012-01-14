//
//  Car+Helpers.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/14/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "Car.h"

@interface Car (Helpers)

+ (Car *)carWithMake:(NSString *)make model:(NSString *)model year:(NSNumber *)year managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (NSString *)makeAndModel;

@end
