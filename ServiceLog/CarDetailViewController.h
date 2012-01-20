//
//  CarDetailViewController.h
//  ServiceLog
//
//  Created by Mark Adams on 1/18/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Car;

@interface CarDetailViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) Car *car;

@end
