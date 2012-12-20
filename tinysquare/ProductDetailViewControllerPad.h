//
//  ProductDetailViewControllerPad.h
//  tinysquare
//
//  Created by  on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ProductDetailViewControllerPad : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *mainImageView;
@property (retain, nonatomic) IBOutlet UIImageView *specialStatusImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *productImagesScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *productDescriptionScrollView;
@property (retain, nonatomic) IBOutlet UIWebView *productSpecWebView;
@property (retain, nonatomic) UIImageView *selectedImageFrame;


- (IBAction)addToBookmarkTapped:(id)sender;
- (IBAction)addToFacebookTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
@end
