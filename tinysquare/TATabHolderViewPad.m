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

#import "TATabHolderViewPad.h"
#import "TATabBarPad.h"
#import "UIApplication+AppDimensions.h"

@implementation TATabHolderViewPad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)layoutSubviews
{
	CGSize selfSize = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
	for(UIView *subview in [self subviews])
	{
		if([subview isKindOfClass:[TATabBarPad class]])
		{
            [subview setFrame:CGRectMake(0, 0, 50, selfSize.height)];
            [subview setNeedsDisplay];
			break;
		}
	}
}

@end
