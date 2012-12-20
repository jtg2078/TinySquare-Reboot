//
//  UIApplication+AppDimensions.m
//  NTIFO
//
//  Created by  on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIApplication+AppDimensions.h"

@implementation UIApplication (AppDimensions)

+(CGSize) currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    //NSLog(@"UIApplication+AppDimensions size:%@", NSStringFromCGSize(size));
    return size;
}

@end
