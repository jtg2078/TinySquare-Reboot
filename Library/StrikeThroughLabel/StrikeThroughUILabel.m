//
//  StrikeThroughUILabel.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/8/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "StrikeThroughUILabel.h"

@implementation StrikeThroughUILabel

- (NSString *)text
{
    return [super text];
}

-(void)setText:(NSString*)text
{
    [super setText:text];
    textSize = [text sizeWithFont:[self font]];
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat strikeLineStartX = 0.0f; // UITextAlignmentLeft
    if(self.textAlignment == UITextAlignmentRight)
        strikeLineStartX = rect.size.width - textSize.width;
    else if(self.textAlignment == UITextAlignmentCenter)
        strikeLineStartX = (rect.size.width - textSize.width) / 2;
    
    CGContextFillRect(context, CGRectMake(strikeLineStartX, rect.size.height / 2, textSize.width, 1));
}

@end
