//
//  CellViewEx.m
//  LayoutManagerEx
//
//  Created by  on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CellViewEx.h"
#import "CellEx.h"
#import "ProductCellViewControllerPad.h"

@implementation CellViewEx

@synthesize indexInPage;
@synthesize cell;
@synthesize pcvc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [cell release];
    [pcvc release];
    [super dealloc];
}

- (void)layoutSubviews
{
    UIView *content = [self viewWithTag:101];
    CGRect newRect = self.frame;
    newRect.origin.x = 0;
    newRect.origin.y = 0;
    content.frame = newRect;
    
    
    if(self.pcvc)
    {
        self.pcvc.imageView.frame = newRect;
        self.pcvc.imageMask.frame = newRect;
        self.pcvc.webView.frame = newRect;
        
        if(newRect.size.width == 512 && newRect.size.height == 512)
        {
            [self.pcvc.imageView setHighlighted:YES];
            [self.pcvc.imageMask setHighlighted:YES];
            self.pcvc.webView.alpha = 1;
        }
        else
        {
            [self.pcvc.imageView setHighlighted:NO];
            [self.pcvc.imageMask setHighlighted:NO];
            self.pcvc.webView.alpha = 0;
        }
    }
}

- (void)configCellContent
{
    if(!self.pcvc)
    {
        NSString *imageName  = [NSString stringWithFormat:@"hotpro_picall-%02d.jpg", self.cell.uniqueId % 12 + 1];
        NSString *htmlName = @"proAll_01_block";
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        ProductCellViewControllerPad *vc = [[ProductCellViewControllerPad alloc] initWithImage:imageName html:htmlName width:frame.size.width height:frame.size.height];
        self.pcvc = vc;
        [vc release];
        self.pcvc.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.pcvc.view];
        NSLog(@"configuring cell for no.%d with frame:%@", self.cell.uniqueId, NSStringFromCGSize(frame.size));
    }
    
}

@end



