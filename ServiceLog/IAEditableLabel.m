//
//  IAEditableLabel.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/15/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "IAEditableLabel.h"

@interface IAEditableLabel ()

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (copy, nonatomic) NSString *rawString;

- (void)setupNumberFormatter;
- (void)updateDisplay;

@end

#pragma mark -

@implementation IAEditableLabel

@synthesize currentNumber;

@synthesize numberFormatter;
@synthesize rawString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self)
        return nil;
    
    [self setupNumberFormatter];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (!self)
        return nil;
    
    [self setupNumberFormatter];
    
    return self;
}

#pragma mark - Getters
- (NSNumber *)currentNumber
{
    return [self.numberFormatter numberFromString:self.rawString];
}

- (NSString *)rawString
{
    if (!rawString)
        rawString = @"";
    
    return rawString;
}

- (void)setupNumberFormatter
{
    numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.maximumFractionDigits = 0;
    numberFormatter.groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    numberFormatter.usesGroupingSeparator = YES;
    numberFormatter.groupingSize = 3;
}

- (void)updateDisplay
{
    NSNumber *number = [self.numberFormatter numberFromString:self.rawString];
    self.text = [self.numberFormatter stringFromNumber:number];
}

#pragma mark - UIResponder Overrides
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)resignFirstResponder
{
    return [super resignFirstResponder];
}

#pragma mark - UIKeyInput Protocol
- (BOOL)hasText
{
    return (self.rawString.length) ? YES : NO;
}

- (void)insertText:(NSString *)text
{
    self.rawString = [self.rawString stringByAppendingString:text];
    [self updateDisplay];
}

- (void)deleteBackward
{
    self.rawString = [self.rawString stringByReplacingCharactersInRange:NSMakeRange(self.rawString.length - 1, 1) withString:@""];
    [self updateDisplay];
}

#pragma mark - UITextInputTraits Protocol
- (UIKeyboardType)keyboardType
{
    return UIKeyboardTypeNumberPad;
}

- (UIKeyboardAppearance)keyboardAppearance
{
    return UIKeyboardAppearanceAlert;
}

@end