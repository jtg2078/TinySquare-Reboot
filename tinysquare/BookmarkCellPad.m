/*
 * ImageDemoFilledCell.m
 * Classes
 * 
 * Created by Jim Dovey on 18/4/2010.
 * 
 * Copyright (c) 2010 Jim Dovey
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "BookmarkCellPad.h"

@implementation BookmarkCellPad

#pragma mark - define

#define CLOSE_BUTTON_IMAGE      @"bookmarkImageDelete.png"
#define FACEBOOK_BUTTON_IMAGE   @"bookmarkImageFacebook.png"
#define EMAIL_BUTTON_IMAGE      @"bookmarkImageEmail.png"
#define LINK_BUTTON_IMAGE       @"bookmarkImageLink.png"
#define BACKGROUND_IMAGE        @"bookmarkCellBackground.png"

#pragma mark - synthesize

@synthesize productImageView;
@synthesize prodctContentWebView;
@synthesize prodctContentImageView;

#pragma mark - dealloc

- (void)dealloc {
    [productImageView release];
    [prodctContentWebView release];
    [prodctContentImageView release];
    [super dealloc];
}

#pragma mark - init

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    // background image
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    bgView.frame = CGRectMake(0, 0, 768, 249);
    [self.contentView addSubview:bgView];
    [bgView release];
    
    productImageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    prodctContentWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    prodctContentImageView = [[UIImageView alloc] init];
    
    productImageView.frame = CGRectMake(95, 19, 302, 210);
    prodctContentWebView.frame = CGRectMake(408, 19, 320, 160);
    prodctContentImageView.frame = CGRectMake(408, 19, 320, 160);
    
    [self.contentView addSubview: productImageView];
    //[self.contentView addSubview: prodctContentWebView];
    [self.contentView addSubview: prodctContentImageView];
    
    self.backgroundColor = [UIColor colorWithWhite: 0.95 alpha: 1.0];
    self.contentView.backgroundColor = self.backgroundColor;
    
    // adding buttons
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(708, 16, 18, 18);
    [closeButton setImage:[UIImage imageNamed:CLOSE_BUTTON_IMAGE] forState:UIControlStateNormal];
    [self.contentView addSubview:closeButton];
    
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookButton.frame = CGRectMake(423, 185, 32, 40);
    [facebookButton setImage:[UIImage imageNamed:FACEBOOK_BUTTON_IMAGE] forState:UIControlStateNormal];
    [self.contentView addSubview:facebookButton];
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emailButton.frame = CGRectMake(470, 185, 32, 40);
    [emailButton setImage:[UIImage imageNamed:EMAIL_BUTTON_IMAGE] forState:UIControlStateNormal];
    [self.contentView addSubview:emailButton];
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    linkButton.frame = CGRectMake(536, 181, 155, 40);
    [linkButton setImage:[UIImage imageNamed:LINK_BUTTON_IMAGE] forState:UIControlStateNormal];
    [linkButton setTitle:NSLocalizedString(@"連結到官網 / 賣場", nil) forState:UIControlStateNormal];
    [self.contentView addSubview:linkButton];
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    /*
    CGSize imageSize = _imageView.image.size;
    CGRect bounds = CGRectInset( self.contentView.bounds, 10.0, 10.0 );
    
    [_title sizeToFit];
    CGRect frame = _title.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = CGRectGetMaxY(bounds) - frame.size.height;
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    _title.frame = frame;
    
    // adjust the frame down for the image layout calculation
    bounds.size.height = frame.origin.y - bounds.origin.y;
    
    if ( (imageSize.width <= bounds.size.width) &&
        (imageSize.height <= bounds.size.height) )
    {
        return;
    }
    
    // scale it down to fit
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MIN(hRatio, vRatio);
    
    [_imageView sizeToFit];
    frame = _imageView.frame;
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    _imageView.frame = frame;
     */
}

@end
