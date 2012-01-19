//
//  CarDetailViewController.m
//  ServiceLog
//
//  Created by Mark Adams on 1/18/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "CarDetailViewController.h"

@interface CarDetailViewController ()

@property (strong, nonatomic) IBOutlet UIView *vehicleView;
@property (strong, nonatomic) IBOutlet UIImageView *vehicleImageView;
@property (strong, nonatomic) IBOutlet UILabel *vehicleLabel;
@property (strong, nonatomic) IBOutlet UIView *editPhotoView;

- (void)imageViewTapped:(id)sender;

@end

#pragma mark -

@implementation CarDetailViewController

@synthesize vehicleView;
@synthesize vehicleImageView;
@synthesize vehicleLabel;
@synthesize editPhotoView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [self.vehicleView addGestureRecognizer:tap];
    
    self.vehicleView.layer.cornerRadius = 4.0;
    self.vehicleView.layer.masksToBounds = YES;
}

- (void)imageViewTapped:(id)sender
{
    NSLog(@"Image view tapped");
}


@end
