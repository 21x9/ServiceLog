//
//  PhotoViewerViewController.m
//  ServiceLog
//
//  Created by Mark Adams on 1/19/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "PhotoViewerViewController.h"

@interface PhotoViewerViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL barsAreHidden;
@property (strong, nonatomic) NSTimer *barVisibilityTimer;

- (void)hideBars;
- (void)showBars;
- (void)startTimer;

@end

#pragma mark -

@implementation PhotoViewerViewController

@synthesize image;

@synthesize scrollView;
@synthesize imageView;
@synthesize barsAreHidden;
@synthesize barVisibilityTimer;

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.image;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        [self showBars];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.barVisibilityTimer invalidate];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

#pragma mark - UIViewController Overrides
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.barsAreHidden)
        [UIApplication sharedApplication].statusBarHidden = NO;
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.barsAreHidden)
        [UIApplication sharedApplication].statusBarHidden = YES;
    
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark - UI Wrangling
- (IBAction)toggleBarVisibility:(id)sender
{
    [self.barVisibilityTimer invalidate];
    
    if (!self.barsAreHidden)
    {
        [self hideBars];
        return;
    }
    
    [self showBars];
}

- (void)hideBars
{
    self.barsAreHidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.alpha = 0.0f;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

- (void)showBars
{
    self.barsAreHidden = NO;
    [self startTimer];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.alpha = 1.0f;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
}

- (void)startTimer
{
    self.barVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideBars) userInfo:nil repeats:NO];
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
