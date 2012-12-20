//
//  DetailCellDelegate.h
//  tinysquare
//
//  Created by ling tsu hsuan on 3/24/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DetailCellDelegate <NSObject>

@optional

- (void)handleImageEvent;
- (void)handleCouponEvent;
- (void)handleBuyEvent;
- (void)handleWebUrlEvent;
- (void)handlePhoneEvent;
- (void)handleShareEvent;
- (void)handleEmailEvent;
- (void)handleAddToCart;

@end
