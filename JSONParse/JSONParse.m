//
//  JSONParse.m
//  JSONParse
//
//  Created by sy on 14-10-16.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "JSONParse.h"
@implementation JSONParse
+(id)ObjectCovertToJson:(id)object
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
@end
@implementation NSDictionary (JSONString)
+(NSString *)dictionaryCoverToString:(NSDictionary *)dictionary
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
                NSString *str= [NSArray arrayCoverToString:object];
                [jsonString appendFormat:@"\"%@\":%@",[allkeys objectAtIndex:i],str];
                
            }else if([object isKindOfClass:[NSDictionary class]])
            {
                 NSString *str= [NSDictionary dictionaryCoverToString:object];
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
+(NSString *)arrayCoverToString:(NSArray *)array
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
                NSString *str= [NSDictionary dictionaryCoverToString:obj];
                [jsonString appendString:str];
            }else if([obj isKindOfClass:[NSDictionary class]])
            {
                NSString *str= [NSDictionary dictionaryCoverToString:obj];
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