//
//  IAEditableLabel.h
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/15/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IAEditableLabel : UILabel <UIKeyInput, UITextInputTraits>

@property (strong, nonatomic) NSNumber *currentNumber;

@end
