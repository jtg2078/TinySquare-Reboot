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


/*
 {
 "code": 1,
 "msg": null,
 "ok": true,
 "rsp": "{
    \"status\":2,
    \"orderid\":524,
    \"products\":[{
        \"pid\":478,
        \"pname\":\"BONE寶家最愛用的【PET GEAR愛踏寵物樓梯 二階（大)】\",
        \"size\":1,
        \"price\":1280,
        \"available\":-1,
        \"isnofee\":true,
        \"amount\":1280
        }],
    \"shippingfees\":0,
    \"noshippingfee\":999,
    \"total\":1280
    }"
 }
*/