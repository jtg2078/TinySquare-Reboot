//
//  FastCell.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "FastCell.h"

@interface CustomContentView : UIView
@end

@implementation CustomContentView

- (void)drawRect:(CGRect)r
{
	[(FastCell*)[[self superview] superview] drawCustomContentView:r];
}

@end

@implementation FastCell

@synthesize backView;
@synthesize customContentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        //backView = [[UIView alloc] initWithFrame:CGRectZero];
        //backView.opaque = YES;
        //[self addSubview:backView];
		customContentView = [[CustomContentView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:customContentView];
        
        
 
    }
    return self;
}

-(void) test
{
    NSLog(@"test");
}

- (void)dealloc {
	[backView removeFromSuperview];
	[backView release];
    
	[customContentView removeFromSuperview];
	[customContentView release];
	[super dealloc];
}

- (void)setFrame:(CGRect)f {
	[super setFrame:f];
	CGRect b = [self bounds];
	b.size.height -= 1; // leave room for the seperator line
	
    [backView setFrame:b];
	[customContentView setFrame:b];
    [self setNeedsDisplay];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
    [backView setNeedsDisplay];
	[customContentView setNeedsDisplay];
}

- (void)drawCustomContentView:(CGRect)r {
	// subclasses should implement this
}

-(void) addBuyItemControllButton
{
    //subclasses should implement this also
}
@end
