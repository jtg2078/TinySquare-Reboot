//
//  ProductCellViewController.h
//  LayoutManagerEx
//
//  Created by  on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductCellViewControllerPad : UIViewController

@property (nonatomic) int cellWidth;
@property (nonatomic) int cellHeight;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *htmlName;
@property (nonatomic) int cellMode;
@property (retain) UIImage *grayScaleImage;
@property (retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImageView *imageMask;
@property (nonatomic, retain) UIWebView *webView;

- (id)initWithImage:(NSString *)aImageName html:(NSString *)aHtmlName width:(int)aWidth height:(int)aHeight;
- (void)initViewAsync;
@end
