//
//  IAActionSheet.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/14/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IAActionSheetDismissalBlock)(NSInteger buttonIndex);

@interface IAActionSheet : UIActionSheet <UIActionSheetDelegate>

- (id)initWithTitle:(NSString *)title dismissalBlock:(IAActionSheetDismissalBlock)block;

@end