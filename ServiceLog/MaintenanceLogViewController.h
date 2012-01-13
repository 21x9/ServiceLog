//
//  MaintenanceLogViewController.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/13/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintenanceLogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
