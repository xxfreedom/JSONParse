//
//  JSONParse.h
//  JSONParse
//
//  Created by sy on 14-10-16.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYModelObject.h"
@interface JSONParse : NSObject
+(id)ObjectConvertToJson:(id)object;
+(id)JsonConvertToObject:(id)json;
@end
@interface NSDictionary (JSONString)
+(NSString *)dictionaryConvertoString:(NSDictionary *)dictionary;
+(void)classObjectSetPorpertyFromDictionary:(NSDictionary *)dictionary
                                ClassObject:(SYModelObject*)classObject;
@end
@interface NSArray (JSONString)
+(NSString *)arrayConvertoString:(NSArray *)array;
@end
@interface NSObject (ClassJsonString)
+(NSString *)objectPropertyConvertoString:(id)object;
+(BOOL)isBaseType:(id)object;
+(BOOL)isJsonType:(id)object;
+(NSDictionary *)getProperty:(id)object WithType:(BOOL)withType;
+(NSString *)getPorpertyTypeFromPorpertyName:(NSString *)name class:(Class)aclass;
-(void)setPorpertyValueForName:(id)value PorpertyName:(NSString *)porpertyName;
@end
