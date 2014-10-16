//
//  JSONParse.h
//  JSONParse
//
//  Created by sy on 14-10-16.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParse : NSObject
+(id)ObjectCovertToJson:(id)object;
+(id)JsonCovertToObject:(id)json;
@end
@interface NSDictionary (JSONString)
+(NSString *)dictionaryCoverToString:(NSDictionary *)dictionary;
@end
@interface NSArray (JSONString)
+(NSString *)arrayCoverToString:(NSArray *)array;
@end