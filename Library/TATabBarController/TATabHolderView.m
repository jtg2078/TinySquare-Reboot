//
// Copyright 2010-2011 Toad Away Limited
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TATabHolderView.h"
#import "TATabBar.h"
#import "ThemeManager.h"

@implementation TATabHolderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        ThemeManager *themeManager = [ThemeManager sharedInstance];
        UIImage *commonBgImage = [UIImage imageNamed:themeManager.commonBgImageName];
        UIImageView *_bgImageView = [[[UIImageView alloc] initWithImage:commonBgImage] autorelease];
        _bgImageView.frame = frame;
        //[self addSubview:_bgImageView];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)layoutSubviews
{
	CGSize selfSize = [self frame].size;

	for(UIView *subview in [self subviews])
	{
		/*
		if([subview isKindOfClass:[UIImageView class]])
		{
			if(subview.tag == 1001)
			{
				subview.frame = CGRectMake(0, selfSize.height - cTabBarHeight - 5, selfSize.width, 5);
			}
		}
		*/
		
		if([subview isKindOfClass:[TATabBar class]])
		{
			[subview setFrame:CGRectMake(0.0f, selfSize.height - cTabBarHeight, selfSize.width, cTabBarHeight)];
			break;
		}
	}
}

@end
