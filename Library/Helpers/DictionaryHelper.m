//
//  DictionaryHelper.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "DictionaryHelper.h"

@implementation NSDictionary (helper)

#define NULL_STRING_REPLACEMENT_VALUE       @""
#define NULL_NUMBER_REPLACEMENT_VALUE       0

- (NSString*) stringForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSString class]]) {
		return NULL_STRING_REPLACEMENT_VALUE;
	}
	return s;
}

- (NSNumber*) numberForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSNumber class]]) { 
        return [NSNumber numberWithInt:NULL_NUMBER_REPLACEMENT_VALUE];
        
	}
	return s;
}

- (NSNumber*) boolForKey:(id)key {
    id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSNumber class]]) { 
        return [NSNumber numberWithBool:NO];
	}
    else {
        if([s intValue])
            return [NSNumber numberWithBool:YES];
    }
    return [NSNumber numberWithBool:NO];
}

- (NSDate*) unixStampStringForKey:(id)key {
    NSString *str = [self stringForKey:key];
    
    if([str length]){
        return [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    }
    
    return [NSDate date];
}

- (NSMutableDictionary*) dictionaryForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSMutableDictionary class]]) {
		return nil;
	}
	return s;
}

- (NSMutableArray*) arrayForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSMutableArray class]]) {
		return nil;
	}
	return s;
}


@end
