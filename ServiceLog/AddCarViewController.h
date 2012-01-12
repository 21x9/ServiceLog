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

@interface AddCarViewController : UIViewController

@property (copy, nonatomic) AddCarViewControllerCancelBlock cancelBlock;
@property (copy, nonatomic) AddCarViewControllerSaveBlock saveBlock;

@end
