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

/*
 -2: 找不到訂單資料。
 -1: 無法取得使用者資料，請先登入帳號。(請加驗證的cookie加入request中)
 0: 未知。
 1: 正常。
 */


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