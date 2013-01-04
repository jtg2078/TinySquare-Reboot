//
//  Constant.h
//  TinySquare
//
//  Created by jason on 12/27/12.
//
//

#import <Foundation/Foundation.h>

extern NSString * const API_APP_ID;

extern NSString * const JSON_KEY_code;
extern NSString * const JSON_KEY_msg;
extern NSString * const JSON_KEY_ok;
extern NSString * const JSON_KEY_rsp;

extern NSString * const CART_KEY_status;
extern NSString * const CART_KEY_orderid;
extern NSString * const CART_KEY_products;
extern NSString * const CART_KEY_shippingfees;
extern NSString * const CART_KEY_noshippingfee;
extern NSString * const CART_KEY_total;

extern NSString * const CART_ITEM_KEY_pid;
extern NSString * const CART_ITEM_KEY_pname;
extern NSString * const CART_ITEM_KEY_size;
extern NSString * const CART_ITEM_KEY_price;
extern NSString * const CART_ITEM_KEY_available;
extern NSString * const CART_ITEM_KEY_isnofee;
extern NSString * const CART_ITEM_KEY_amount;

extern int const GET_CART_CODE_cart_not_exist;
extern int const GET_CART_CODE_not_logged_in;
extern int const GET_CART_CODE_unknown_state;
extern int const GET_CART_CODE_ok;

extern int const UPDATE_CART_CODE_db_update_error;
extern int const UPDATE_CART_CODE_db_delete_error;
extern int const UPDATE_CART_CODE_db_add_error;
extern int const UPDATE_CART_CODE_out_of_stock;
extern int const UPDATE_CART_CODE_pid_not_found;
extern int const UPDATE_CART_CODE_cart_not_found;
extern int const UPDATE_CART_CODE_not_logged_in;
extern int const UPDATE_CART_CODE_unknown;
extern int const UPDATE_CART_CODE_db_add_success;
extern int const UPDATE_CART_CODE_db_update_success;
extern int const UPDATE_CART_CODE_db_delete_success;

extern int const CREATE_CART_CODE_pid_not_found;
extern int const CREATE_CART_CODE_nothing_added;
extern int const CREATE_CART_CODE_not_logged_in;
extern int const CREATE_CART_CODE_unknown;
extern int const CREATE_CART_CODE_success;

extern int const GET_ALL_CARTS_ok;

extern int const CART_STATUS_not_created;
extern int const CART_STATUS_temp;
extern int const CART_STATUS_proceeding;
extern int const CART_STATUS_in_transaction;
extern int const CART_STATUS_success;
extern int const CART_STATUS_failure;

extern int const CART_CHECK_order_not_found;
extern int const CART_CHECK_not_logged_in;
extern int const CART_CHECK_unknown;
extern int const CART_CHECK_ok;

extern int const CHECK_OUT_unknown_error1;
extern int const CHECK_OUT_unknown_error2;
extern int const CHECK_OUT_unknown_error3;
extern int const CHECK_OUT_invalid_total;
extern int const CHECK_OUT_failed_transaction;
extern int const CHECK_OUT_completed_transaction;
extern int const CHECK_OUT_already_in_transaction;
extern int const CHECK_OUT_contained_out_of_stock;
extern int const CHECK_OUT_order_id_not_found;
extern int const CHECK_OUT_not_logged_in;
extern int const CHECK_OUT_unknown;
extern int const CHECK_OUT_success;
extern int const CHECK_OUT_failure;

extern BOOL const USE_ANDROID_SHOPPING_CART_MECHANISM;
