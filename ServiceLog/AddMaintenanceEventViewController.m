//
//  AddMaintenanceEventViewController.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/15/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "AddMaintenanceEventViewController.h"

@interface AddMaintenanceEventViewController ()

@property (strong, nonatomic) IBOutlet UINavigationItem *formNavigationItem;
@property (strong, nonatomic) IBOutlet UIView *dimmingView;
@property (strong, nonatomic) IBOutlet UIView *mileageInputView;
@property (strong, nonatomic) IBOutlet UITextField *mileageTextField;

- (void)presentMileageInputView;
- (void)dismissMileageInputViewWithCompletionHandler:(void (^)(BOOL finished))completionHandler;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

#pragma mark - 

@implementation AddMaintenanceEventViewController

@synthesize maintenanceType;
@synthesize managedObjectContext;
@synthesize completionBlock;

@synthesize formNavigationItem;
@synthesize dimmingView;
@synthesize mileageInputView;
@synthesize mileageTextField;

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mileageInputView.layer.cornerRadius = 5.0f;
    self.mileageInputView.layer.masksToBounds = YES;

    self.formNavigationItem.title = [[Maintenance maintenanceTypes] objectAtIndex:self.maintenanceType];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentMileageInputView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

#pragma mark - Interface Helpers
- (void)presentMileageInputView
{
    __block CGRect frame = self.mileageInputView.frame;
    frame.origin.y = CGRectGetMaxY(self.view.frame);
    self.mileageInputView.frame = frame;
    [self.mileageTextField becomeFirstResponder];
    
    [UIView animateWithDuration:0.33 animations:^{
        frame.origin.y = 44.0f;
        self.mileageInputView.frame = frame;
        self.dimmingView.alpha = 0.8;
    }];
}

- (void)dismissMileageInputViewWithCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.mileageTextField resignFirstResponder];
    __block CGRect frame = self.mileageInputView.frame;
    frame.origin.y = CGRectGetMaxY(self.view.frame);
    
    [UIView animateWithDuration:0.33 animations:^{
        self.mileageInputView.frame = frame;
        self.dimmingView.alpha = 0.0f;
    } completion:completionHandler];
}

#pragma mark - Interface Actions
- (IBAction)cancel:(id)sender
{
    [self dismissMileageInputViewWithCompletionHandler:^(BOOL finished) {
        self.completionBlock(NO);
    }];
}

- (IBAction)save:(id)sender
{
    [self dismissMileageInputViewWithCompletionHandler:^(BOOL finished) {
        self.completionBlock(YES);
    }];
}

@end
