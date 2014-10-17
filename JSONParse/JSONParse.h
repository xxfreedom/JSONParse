//
//  JSONParse.h
//  JSONParse
//
//  Created by sy on 14-10-16.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParse : NSObject
+(id)ObjectConvertToJson:(id)object;
+(id)JsonConvertToObject:(id)json;
@end
@interface NSDictionary (JSONString)
+(NSString *)dictionaryConvertoString:(NSDictionary *)dictionary;
@end
@interface NSArray (JSONString)
+(NSString *)arrayConvertoString:(NSArray *)array;
@end
@interface NSObject (ClassJsonString)
+(NSString *)objectPropertyConvertoString:(id)object;
@end
