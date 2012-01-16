//
//  AddMaintenanceEventViewController.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/15/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "AddMaintenanceEventViewController.h"
#import "IAEditableLabel.h"
#import "Car.h"

@interface AddMaintenanceEventViewController ()

@property (strong, nonatomic) IBOutlet UINavigationItem *formNavigationItem;
@property (strong, nonatomic) IBOutlet UIView *dimmingView;
@property (strong, nonatomic) IBOutlet UIView *mileageInputView;
@property (strong, nonatomic) IBOutlet IAEditableLabel *mileageLabel;

- (void)presentMileageInputView;
- (void)dismissMileageInputView;
- (void)saveMileageInputView;
- (void)animateMileageInputViewToYCoordinate:(CGFloat)newY completionHandler:(void (^)(BOOL finished))completionHandler;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

#pragma mark - 

@implementation AddMaintenanceEventViewController

@synthesize car;
@synthesize maintenanceType;
@synthesize managedObjectContext;
@synthesize completionBlock;

@synthesize formNavigationItem;
@synthesize dimmingView;
@synthesize mileageInputView;
@synthesize mileageLabel;

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mileageInputView.layer.cornerRadius = 5.0f;
    self.mileageInputView.layer.masksToBounds = YES;

    self.formNavigationItem.title = [[Maintenance maintenanceTypes] objectAtIndex:self.maintenanceType];
    
    self.mileageLabel.layer.cornerRadius = 5.0f;
    self.mileageLabel.layer.masksToBounds = YES;
    self.mileageLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mileageLabel.layer.borderWidth = 1.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentMileageInputView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

#pragma mark - Interface Helpers
- (void)presentMileageInputView
{
    __block CGRect frame = self.mileageInputView.frame;
    frame.origin.y = CGRectGetMaxY(self.view.frame);
    self.mileageInputView.frame = frame;
    [self.mileageLabel becomeFirstResponder];
    
    [UIView animateWithDuration:0.33 animations:^{
        frame.origin.y = 37.0f;
        self.mileageInputView.frame = frame;
        self.dimmingView.alpha = 0.8;
    }];
}

- (void)saveMileageInputView
{
    [self animateMileageInputViewToYCoordinate:CGRectGetMinY(self.view.frame) - CGRectGetHeight(self.mileageInputView.frame) completionHandler:^(BOOL finished) {
        self.completionBlock(YES);
    }];
}

- (void)dismissMileageInputView
{
    [self animateMileageInputViewToYCoordinate:CGRectGetMaxY(self.view.frame) completionHandler:^(BOOL finished) {
        
        self.completionBlock(NO);
    }];
}

- (void)animateMileageInputViewToYCoordinate:(CGFloat)newY completionHandler:(void (^)(BOOL finished))completionHandler
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.mileageLabel resignFirstResponder];
    __block CGRect frame = self.mileageInputView.frame;
    frame.origin.y = newY;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mileageInputView.frame = frame;
        self.mileageInputView.alpha = 0.0f;
        self.dimmingView.alpha = 0.0f;
    } completion:completionHandler];
}

#pragma mark - Interface Actions
- (IBAction)cancel:(id)sender
{
    [self dismissMileageInputView];
}

- (IBAction)save:(id)sender
{
    Maintenance *maintenance = [Maintenance maintenanceWithType:self.maintenanceType mileage:self.mileageLabel.currentNumber datePerformed:[NSDate date] managedObjectContext:self.managedObjectContext];
    [self.car addMaintenanceEventsObject:maintenance];
    NSError *childError = nil;
    
    if (![self.managedObjectContext save:&childError])
        NSLog(@"Couldn't save child context. %@, %@", childError, childError.userInfo);
    
    [self saveMileageInputView];
}

@end
