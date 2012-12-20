//
//  StrikeThroughUILabel.h
//  tinysquare
//
//  Created by ling tsu hsuan on 3/8/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrikeThroughUILabel : UILabel {
    CGSize textSize;
}


-(NSString *)text;
-(void)setText:(NSString *)text;

@end
