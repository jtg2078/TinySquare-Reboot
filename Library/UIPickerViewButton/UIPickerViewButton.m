//
//  UIPickerViewButton.m
//  TaiwanTaxi
//
//  Created by ling tsu hsuan on 7/26/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "UIPickerViewButton.h"

@implementation UIPickerViewButton

@synthesize inputView;
@synthesize inputAccessoryView;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

@end
