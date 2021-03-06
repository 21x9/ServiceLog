//
//  AddMaintenanceEventViewController.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/15/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Maintenance.h"
#import "Maintenance+Helpers.h"

typedef void (^AddMaintenanceEventViewControllerCompletionBlock)(BOOL saved);

@class Car;

@interface AddMaintenanceEventViewController : UIViewController

@property (strong, nonatomic) Car *car;
@property (nonatomic) MaintenanceType maintenanceType;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (copy, nonatomic) AddMaintenanceEventViewControllerCompletionBlock completionBlock;

@end
