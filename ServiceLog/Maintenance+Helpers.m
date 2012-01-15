//
//  Maintenance+Helpers.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/14/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "Maintenance+Helpers.h"

@implementation Maintenance (Helpers)

+ (Maintenance *)maintenanceWithType:(MaintenanceType)type mileage:(NSNumber *)mileage datePerformed:(NSDate *)datePerformed managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Maintenance *maintenance = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
    maintenance.type = [NSNumber numberWithInteger:type];
    maintenance.datePerformed = datePerformed;
    maintenance.mileage = mileage;
    
    return maintenance;
}

- (NSString *)typeString
{
    switch ([self.type integerValue])
    {
        case MaintenanceTypeAirFilter:
            return @"Air Filter";
            break;
        case MaintenanceTypeFrontBrakes:
            return @"Front Brakes";
            break;
        case MaintenanceTypeOilFilter:
            return @"Oil Filter";
            break;
        case MaintenanceTypeRearBrakes:
            return @"Rear Brakes";
            break;
        case MaintenanceTypeTireRotation:
            return @"Tire Rotation";
            break;
        default:
            return nil;
            break;
    }
}

+ (NSArray *)maintenanceTypes
{
    NSMutableArray *types = [NSMutableArray array];
    
    for (MaintenanceType type = 0; type < MaintenanceTypeNumberOfEvents; type++)
    {
        switch (type)
        {
            case MaintenanceTypeAirFilter:
                [types addObject:@"Air Filter"];
                break;
            case MaintenanceTypeOilFilter:
                [types addObject:@"Oil Filter"];
                break;
            case MaintenanceTypeTireRotation:
                [types addObject:@"Tire Rotation"];
                break;
            case MaintenanceTypeFrontBrakes:
                [types addObject:@"Front Brakes"];
                break;
            case MaintenanceTypeRearBrakes:
                [types addObject:@"Rear Brakes"];
                break;
            default:
                break;
        }
    }
    
    return [types copy];
}

@end
