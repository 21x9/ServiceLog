//
//  AddCarViewController.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/11/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "AddCarViewController.h"
#import "Car.h"

@interface AddCarViewController ()

@property (strong, nonatomic) IBOutlet UITextField *makeTextField;
@property (strong, nonatomic) IBOutlet UITextField *modelTextField;
@property (strong, nonatomic) IBOutlet UITextField *yearTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

#pragma mark -

@implementation AddCarViewController

@synthesize managedObjectContext;
@synthesize cancelBlock;
@synthesize doneBlock;

@synthesize makeTextField;
@synthesize modelTextField;
@synthesize yearTextField;

#pragma mark - View Lifecycle
- (void)viewDidAppear:(BOOL)animated
{
    [self.makeTextField becomeFirstResponder];
}

- (IBAction)cancel:(id)sender
{
    self.cancelBlock();
}

- (IBAction)done:(id)sender
{
    Car *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:self.managedObjectContext];
    car.make = self.makeTextField.text;
    car.model = self.modelTextField.text;
    car.year = [NSNumber numberWithInteger:[self.yearTextField.text integerValue]];
    
    [self.managedObjectContext performBlock:^{
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error])
            NSLog(@"Could not save discardable context. %@, %@", error, error.userInfo);
    }];
    
    self.doneBlock();
}

@end
