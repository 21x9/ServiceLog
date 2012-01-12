//
//  AddCarViewController.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/11/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "AddCarViewController.h"

@interface AddCarViewController ()

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

#pragma mark -

@implementation AddCarViewController

@synthesize cancelBlock;
@synthesize saveBlock;

- (IBAction)cancel:(id)sender
{
    self.cancelBlock();
}

- (IBAction)done:(id)sender
{
    self.saveBlock();
}

@end
