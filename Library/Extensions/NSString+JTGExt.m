//
//  NSString+JTGExt.m
//  TestNetworkUpdate
//
//  Created by jason on 2011/8/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+JTGExt.h"


@implementation NSString (JTGExt)

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define SEPARATOR                                   @","

- (NSData *) decryptHexStringWithKey:(NSString *)keyInHex iv:(NSString *)ivInHex {
	NSData *key = [keyInHex hexStringToByte];
	NSData *iv = [ivInHex hexStringToByte];
	NSData *cipher = [self hexStringToByte];
	
	// decrypt code using parameters from above
	const uint8_t * p = [cipher bytes];
	size_t length = [cipher length];
	size_t bufferSize = length + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	memset(buffer, 0, bufferSize); // lesson learned, possible culprit:  + kCCBlockSizeAES128 in line above
	size_t numBytesDecrypted = 0;
	
	CCCryptorStatus result = CCCrypt(kCCDecrypt, 
									 kCCAlgorithmAES128, 
									 0, 
									 [key bytes], 
									 [key length],
									 [iv bytes],
									 p,
									 length, 
									 buffer, 
									 bufferSize,
									 &numBytesDecrypted);
	
	if (result != kCCSuccess) {
		free(buffer);
		return nil;
	}
	
	NSData *decrypted = [NSData dataWithBytesNoCopy:buffer 
											 length:numBytesDecrypted 
									   freeWhenDone:YES];
	return decrypted;
}

- (NSData *) hexStringToByte{
	
#define HEX_TO_DEC(h) (h < 'a' ? (h - '0'): (h - 'a' + 10))
	const char *pos = [self cStringUsingEncoding:NSUTF8StringEncoding];
	int len = [self length] / 2;
	unsigned char buffer[len];
	for(int i = 0; i < len; i++){
		int num = HEX_TO_DEC(*pos) << 4;
		pos++;
		num+= HEX_TO_DEC(*pos);
		pos++;
		buffer[i] = num;
	}
	NSData *data = [NSData dataWithBytes:buffer length:len];
	return data;
}

- (NSString *) md5InHexString {
	const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

- (UIColor *) rgbCommaStringToUIColor
{
    NSArray *array = [self componentsSeparatedByString:SEPARATOR];
    
    UIColor *color = RGB([[array objectAtIndex:0] intValue], 
                         [[array objectAtIndex:1] intValue], 
                         [[array objectAtIndex:2] intValue]);
    return color;
}

@end
