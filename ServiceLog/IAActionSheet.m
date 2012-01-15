//
//  IAActionSheet.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/14/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "IAActionSheet.h"

@interface IAActionSheet ()

@property (copy, nonatomic) IAActionSheetDismissalBlock dismissalBlock;

@end

#pragma mark -

@implementation IAActionSheet

@synthesize dismissalBlock;

- (id)initWithTitle:(NSString *)title dismissalBlock:(IAActionSheetDismissalBlock)block
{
    self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (!self)
        return nil;
    
    dismissalBlock = block;
    
    return self;
}

#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.dismissalBlock(buttonIndex);
}

@end
