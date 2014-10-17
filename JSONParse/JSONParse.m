//
//  JSONParse.m
//  JSONParse
//
//  Created by sy on 14-10-16.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "JSONParse.h"
#import <objc/runtime.h>
@implementation JSONParse
+(id)ObjectConvertToJson:(id)object
{
    id json;
    if([NSJSONSerialization isValidJSONObject:object])
    {
        NSError *error;
        json=[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if(error)
        {
            NSLog(@"%s error:%@",__func__,[error description]);
        }
    }
    return json;
}
+(id)JsonConvertToObject:(id)json;
{
    id object;
    NSError *error;
    object=[NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers|NSJSONReadingMutableContainers error:&error];
    if(error)
    {
        NSLog(@"%s error:%@",__func__,[error description]);
    }
    return object;
}
@end
@implementation NSDictionary (JSONString)
+(NSString *)dictionaryConvertoString:(NSDictionary *)dictionary
{
    NSMutableString *jsonString=nil;
    if(dictionary!=nil&&[NSJSONSerialization isValidJSONObject:dictionary])
    {
        jsonString=[[NSMutableString alloc]init];
        NSArray *allkeys=[dictionary allKeys];
        for (int i=0; i<[allkeys count]; i++) {
            if(i==0)
               [jsonString appendString:@"{"];
            else
                [jsonString appendString:@","];
            id object=dictionary[[allkeys objectAtIndex:i]];
            if([object isKindOfClass:[NSArray class]])
            {
                NSString *str= [NSArray arrayConvertoString:object];
                [jsonString appendFormat:@"\"%@\":%@",[allkeys objectAtIndex:i],str];
                
            }else if([object isKindOfClass:[NSDictionary class]])
            {
                 NSString *str= [NSDictionary dictionaryConvertoString:object];
                 [jsonString appendFormat:@"\"%@\":%@",[allkeys objectAtIndex:i],str];
            }else
            {
                if([object isKindOfClass:[NSNumber class]])
                {
                    [jsonString appendFormat:@"\"%@\":\"%@\"",[allkeys objectAtIndex:i],[object descriptionWithLocale:[NSLocale currentLocale]]];
                }else if(object == [NSNull null])
                {
                    [jsonString appendFormat:@"\"%@\":\"null\"",[allkeys objectAtIndex:i]];
                }else
                {
                    [jsonString appendFormat:@"\"%@\":\"%@\"",[allkeys objectAtIndex:i],object];
                }
            }
            if(i==([allkeys count]-1))
            [jsonString appendString:@"}"];
                
        }
    }
    return jsonString;
}
@end
@implementation NSArray (JSONString)
+(NSString *)arrayConvertoString:(NSArray *)array
{
    NSMutableString *jsonString=nil;
    if(array!=nil&&[NSJSONSerialization isValidJSONObject:array])
    {
        jsonString=[[NSMutableString alloc]init];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if(idx==0)
                [jsonString appendString:@"["];
            else
                [jsonString appendString:@","];
            if([obj isKindOfClass:[NSArray class]])
            {
                NSString *str= [NSDictionary dictionaryConvertoString:obj];
                [jsonString appendString:str];
            }else if([obj isKindOfClass:[NSDictionary class]])
            {
                NSString *str= [NSDictionary dictionaryConvertoString:obj];
                [jsonString appendString:str];
            }else
            {
                if([obj isKindOfClass:[NSNumber class]])
                {
                    [jsonString appendFormat:@"\"%@\"",[obj descriptionWithLocale:[NSLocale currentLocale]]];
                }else if(obj == [NSNull null])
                {
                    [jsonString appendFormat:@"\"null\""];
                }else
                {
                    [jsonString appendFormat:@"\"%@\"",obj];
                  
                }
            }
            if(idx==([array count]-1))
                [jsonString appendString:@"]"];
        }];
    }
    return jsonString;
}
@end
@implementation NSObject (ClassJsonString)

+(NSString *)objectPropertyConvertoString:(id)object
{
    NSMutableString *jsonString;
    NSDictionary *dic=[ NSObject getProperty:object];
    jsonString =[[NSMutableString alloc]initWithString:[NSDictionary dictionaryConvertoString:dic]];
    return jsonString;
}
+(BOOL)isBaseType:(id)object
{
    if([object isKindOfClass:[NSObject class]]
       &&![object isKindOfClass:[NSString class]]
       &&![object isKindOfClass:[NSDictionary class]]
       &&![object isKindOfClass:[NSArray class]]&&![object isKindOfClass:[NSNumber class]])
    {
        return NO;
    }
    return YES;
    
}
+(NSDictionary *)getProperty:(id)object
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    unsigned int numIvars;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    
    Ivar *vars = class_copyIvarList([object class], &numIvars);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        Ivar thisValue=vars[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [object valueForKey:propertyName];
//获取属性的类型
//        NSString * dataType = [NSString stringWithCString:ivar_getTypeEncoding(thisValue) encoding:NSUTF8StringEncoding];
        NSString *dicKey=[NSString stringWithFormat:@"%@",propertyName];
        if (propertyValue)
        {
            if([NSObject isBaseType:propertyValue])
            {
               [props setObject:propertyValue forKey:dicKey];
            }else
            {
                NSDictionary *property=[NSObject getProperty:propertyValue];
                [props setObject:property forKey:dicKey];
            }
            
        }
        else [props setObject:@"nil" forKey:dicKey];
    }
    free(properties);
    NSLog(@"propertiees:%@",props);
    return props;
}
/* 获取对象的所有方法 */
+(void)printMothList
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++)
    {
        Method temp_f = mothList_f[i];
        //        IMP imp_f = method_getImplementation(temp_f);
        //        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,
              [NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}

@end