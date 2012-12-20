//
//  UIApplication+AppDimensions.h
//  NTIFO
//
//  Created by  on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication (AppDimensions)
+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;
@end
