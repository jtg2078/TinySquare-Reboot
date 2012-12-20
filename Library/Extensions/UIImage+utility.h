//
//  UIImage+grayscale.h
//  LayoutManagerEx
//
//  Created by  on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (utility)
- (UIImage *)convertToGrayscale;
- (UIImage *)imageByScalingToSize:(CGSize)newSize;
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
