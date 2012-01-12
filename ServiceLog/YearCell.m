//
//  YearCell.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/11/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "YearCell.h"

@implementation YearCell

@synthesize pickerView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (!self)
        return nil;
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pickerView.showsSelectionIndicator = YES;
    
    return self;
}

#pragma mark - UIKeyInput Protocol Methods
- (BOOL)hasText
{
    return YES;
}

- (void)insertText:(NSString *)text
{
    return;
}

- (void)deleteBackward
{
    return;
}

#pragma mark - UIResponder Overrides
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)resignFirstResponder
{
    self.selected = NO;
    return YES;
}

- (UIView *)inputView
{
    return self.pickerView;
}

@end
