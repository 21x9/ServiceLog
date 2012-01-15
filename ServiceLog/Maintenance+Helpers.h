//
//  Maintenance+Helpers.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/14/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "Maintenance.h"

typedef enum
{
    MaintenanceTypeAirFilter = 0,
    MaintenanceTypeOilFilter,
    MaintenanceTypeTireRotation,
    MaintenanceTypeFrontBrakes,
    MaintenanceTypeRearBrakes,
    MaintenanceTypeNumberOfEvents
} MaintenanceType;

@interface Maintenance (Helpers)

+ (Maintenance *)maintenanceWithType:(MaintenanceType)type mileage:(NSNumber *)mileage datePerformed:(NSDate *)datePerformed managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (NSString *)typeString;

+ (NSArray *)maintenanceTypes;

@end
