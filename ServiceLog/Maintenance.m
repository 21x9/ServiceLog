//
//  Maintenance.m
//  ServiceLog
//
//  Created by Mark Adams on 1/17/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "Maintenance.h"
#import "Car.h"


@implementation Maintenance

@dynamic datePerformed;
@dynamic mileage;
@dynamic type;
@dynamic sectionIdentifier;
@dynamic car;

- (NSString *)sectionIdentifier
{        
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *identifier = [self primitiveValueForKey:@"sectionIdentifier"];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if (!identifier)
    {
        NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self.datePerformed];
        identifier = [NSString stringWithFormat:@"%d", (components.year * 1000) + components.month];
        [self setPrimitiveValue:identifier forKey:@"sectionIdentifier"];
    }
    
    return identifier;
}

- (void)setDatePerformed:(NSDate *)datePerformed
{    
    [self willChangeValueForKey:@"datePerformed"];
    [self setPrimitiveValue:datePerformed forKey:@"datePerformed"];
    [self didChangeValueForKey:@"datePerformed"];
    
    [self setPrimitiveValue:nil forKey:@"sectionIdentifier"];
}

+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    return [NSSet setWithObject:@"datePerformed"];
}

@end
