//
//  Constant.m
//  TinySquare
//
//  Created by jason on 12/27/12.
//
//

#import "Constant.h"

NSString * const API_APP_ID = @"10";

NSString * const JSON_KEY_code = @"code";
NSString * const JSON_KEY_msg = @"msg";
NSString * const JSON_KEY_ok = @"ok";
NSString * const JSON_KEY_rsp = @"rsp";

NSString * const CART_KEY_status = @"status";
NSString * const CART_KEY_orderid = @"orderid";
NSString * const CART_KEY_products = @"products";
NSString * const CART_KEY_shippingfees = @"shippingfees";
NSString * const CART_KEY_noshippingfee = @"noshippingfee";
NSString * const CART_KEY_total = @"total";

NSString * const CART_ITEM_KEY_pid = @"pid";
NSString * const CART_ITEM_KEY_pname = @"pname";
NSString * const CART_ITEM_KEY_size = @"size";
NSString * const CART_ITEM_KEY_price = @"price";
NSString * const CART_ITEM_KEY_available = @"available";
NSString * const CART_ITEM_KEY_isnofee = @"isnofee";
NSString * const CART_ITEM_KEY_amount = @"amount";

int const GET_CART_CODE_cart_not_exist = -2;
int const GET_CART_CODE_not_logged_in = -1;
int const GET_CART_CODE_unknown_state = 0;
int const GET_CART_CODE_ok = 1;