//
//  AddCarViewController.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/11/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AddCarViewControllerCancelBlock)();
typedef void (^AddCarViewControllerSaveBlock)();

@interface AddCarViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (copy, nonatomic) AddCarViewControllerCancelBlock cancelBlock;
@property (copy, nonatomic) AddCarViewControllerSaveBlock doneBlock;

@end
