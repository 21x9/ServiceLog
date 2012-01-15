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

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles dismissalBlock:(IAActionSheetDismissalBlock)block;

@end