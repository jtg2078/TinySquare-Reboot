//
//  StoreListingCellView.m
//  TinyStore
//
//  Created by jason on 2011/9/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreListingCell.h"


@implementation StoreListingCell

#pragma mark -
#pragma mark synthesize

@synthesize detailViewImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		a = -1;
		b = -1;
		c = -1;
		d = -1;
		UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		self.backgroundView = bgView;
		[bgView release];
		
		self.clipsToBounds = YES;
		
		detailViewImage = [[UIImageView alloc] init];
		detailViewImage.frame = CGRectMake(0, 44, 320, 49);
		[self.backgroundView addSubview:detailViewImage];
    }
    return self;
}

- (void) layoutSubviews {
	
	[super layoutSubviews];
	
	self.textLabel.frame = CGRectMake(10, 
									  2, 
									  self.textLabel.frame.size.width, 
									  self.textLabel.frame.size.height);
	self.detailTextLabel.frame = CGRectMake(10, 
											24, 
											self.detailTextLabel.frame.size.width, 
											self.detailTextLabel.frame.size.height);
	
	/*
	if(a != -1 && b != -1 && c != -1 && d != -1)
	{
		self.textLabel.frame = CGRectMake(a, 
										  b, 
										  self.textLabel.frame.size.width, 
										  self.textLabel.frame.size.height);
		self.detailTextLabel.frame = CGRectMake(c, 
												d, 
												self.detailTextLabel.frame.size.width, 
												self.detailTextLabel.frame.size.height);
	}
	else
	{
		a = self.textLabel.frame.origin.x;
		b = self.textLabel.frame.origin.y;
		c = self.detailTextLabel.frame.origin.x;
		d = self.detailTextLabel.frame.origin.y;
	}
	*/
	
	 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [detailViewImage release];
    [super dealloc];
}


@end
