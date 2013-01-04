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

int const UPDATE_CART_CODE_db_update_error = -13;
int const UPDATE_CART_CODE_db_delete_error = -12;
int const UPDATE_CART_CODE_db_add_error = -11;
int const UPDATE_CART_CODE_out_of_stock = -4;
int const UPDATE_CART_CODE_pid_not_found = -3;
int const UPDATE_CART_CODE_cart_not_found = -2;
int const UPDATE_CART_CODE_not_logged_in = -1;
int const UPDATE_CART_CODE_unknown = 0;
int const UPDATE_CART_CODE_db_add_success = 1;
int const UPDATE_CART_CODE_db_update_success = 2;
int const UPDATE_CART_CODE_db_delete_success = 3;

int const CREATE_CART_CODE_pid_not_found = -3;
int const CREATE_CART_CODE_nothing_added = -2;
int const CREATE_CART_CODE_not_logged_in = -1;
int const CREATE_CART_CODE_unknown = 0;
int const CREATE_CART_CODE_success = 1;

int const GET_ALL_CARTS_ok = 1;

int const CART_STATUS_not_created = 0;
int const CART_STATUS_temp = 1;
int const CART_STATUS_proceeding = 2;
int const CART_STATUS_in_transaction = 3;
int const CART_STATUS_success = 4;
int const CART_STATUS_failure = 5;

int const CART_CHECK_order_not_found = -2;
int const CART_CHECK_not_logged_in = -1;
int const CART_CHECK_unknown = 0;
int const CART_CHECK_ok = 1;

int const CHECK_OUT_unknown_error1 = -10;
int const CHECK_OUT_unknown_error2 = -9;
int const CHECK_OUT_unknown_error3 = -8;
int const CHECK_OUT_invalid_total = -7;
int const CHECK_OUT_failed_transaction = -6;
int const CHECK_OUT_completed_transaction = -5;
int const CHECK_OUT_already_in_transaction = -4;
int const CHECK_OUT_contained_out_of_stock = -3;
int const CHECK_OUT_order_id_not_found = -2;
int const CHECK_OUT_not_logged_in = -1;
int const CHECK_OUT_unknown = 0;
int const CHECK_OUT_success = 1;
int const CHECK_OUT_failure = 2;

BOOL const USE_ANDROID_SHOPPING_CART_MECHANISM = YES;
