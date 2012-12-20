//
//  NSString+JTGExt.h
//  TestNetworkUpdate
//
//  Created by jason on 2011/8/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>


@interface NSString (JTGExt)
- (NSData *) decryptHexStringWithKey:(NSString *)keyInHex iv:(NSString *)ivInHex;
- (NSData *) hexStringToByte;
- (NSString *) md5InHexString;
- (UIColor *) rgbCommaStringToUIColor;
@end
