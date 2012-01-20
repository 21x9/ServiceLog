//
//  PhotoViewerViewController.m
//  ServiceLog
//
//  Created by Mark Adams on 1/19/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "PhotoViewerViewController.h"

@interface PhotoViewerViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL barsAreHidden;
@property (strong, nonatomic) NSTimer *barHideTimer;

- (void)hideBars;
- (IBAction)showBars;

@end

#pragma mark -

@implementation PhotoViewerViewController

@synthesize image;

@synthesize scrollView;
@synthesize imageView;
@synthesize barsAreHidden;
@synthesize barHideTimer;

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.image;
    
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 2.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.barHideTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideBars) userInfo:nil repeats:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.barHideTimer invalidate];
    
    if (self.barsAreHidden)
    {
        [self showBars];
    }
}

#pragma mark - UIViewController Overrides
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - UI Wrangling
- (void)hideBars
{
    if (!self.view.window)
        return;
    
    if (self.barsAreHidden)
        return;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.alpha = 0.0f;
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.barsAreHidden = YES;
}

- (IBAction)showBars
{
    if (!self.barsAreHidden)
    {
        [self hideBars];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.alpha = 1.0f;
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideBars) userInfo:nil repeats:NO];
    self.barsAreHidden = NO;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGRect scrollBounds = self.scrollView.bounds;
    CGRect imageViewFrame = self.imageView.frame;
    
    if (CGRectGetWidth(imageViewFrame) < CGRectGetWidth(scrollBounds))
        imageViewFrame.origin.x = (CGRectGetWidth(scrollBounds) - CGRectGetWidth(imageViewFrame)) / 2;
    else
        imageViewFrame.origin.x = 0.0f;
    
    if (CGRectGetHeight(imageViewFrame) < CGRectGetHeight(scrollBounds))
        imageViewFrame.origin.y = (CGRectGetHeight(scrollBounds) - CGRectGetHeight(imageViewFrame)) / 2;
    else
        imageViewFrame.origin.y = 0.0f;
    
    self.imageView.frame = imageViewFrame;
}

@end
