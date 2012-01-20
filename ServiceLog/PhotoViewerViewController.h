//
//  PhotoViewerViewController.h
//  ServiceLog
//
//  Created by Mark Adams on 1/19/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewerViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIImage *image;

@end
