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
+(void)classObjectSetPorpertyFromDictionary:(NSDictionary *)dictionary
                                ClassObject:(SYModelObject*)classObject
{
    NSDictionary *mapTable=[classObject getPropertyMapTable];
    if(dictionary&&classObject&&mapTable)
    {
        NSArray *allMapPorperty=[mapTable allKeys];
        [allMapPorperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *realPorperty=mapTable[obj];
            if(![realPorperty isEqual:[NSNull null]]&&![obj isEqual:[NSNull null]])
            {
                id value=[dictionary valueForKey:obj];
                if([value isEqual:[NSNull null]])
                {
                    value=nil;
                
                }else if([NSObject isBaseType:value])
                {
                    NSString *stringType =[NSObject getPorpertyTypeFromPorpertyName:realPorperty class:[classObject class]];
                    if ([stringType hasPrefix:@"@"]) {
                        // handle class case
                        NSLog(@"handle class case");
                    } else
                    {
                        
                    }
                }else if([value isKindOfClass:[NSDictionary class]])
                {
                    NSString *stringType =[NSObject getPorpertyTypeFromPorpertyName:realPorperty class:[classObject class]];
                    if([NSClassFromString(stringType) isSubclassOfClass:[NSDictionary class]])
                    {
                        
                    }else
                    {
                        id aValue;
                        aValue=[[NSClassFromString(stringType) alloc]init];
                        [NSDictionary classObjectSetPorpertyFromDictionary:value ClassObject:aValue];
                    }
                    
                }else if([value isKindOfClass:[NSArray class]])
                {
                    NSString *classType=[classObject getArrayPropertyItemClassMapTable][realPorperty];
                    NSMutableArray *items=[[NSMutableArray alloc]init];
                    [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        id aValue;
                        aValue=[[NSClassFromString(classType) alloc]init];
                        [NSDictionary classObjectSetPorpertyFromDictionary:obj ClassObject:aValue];
                        [items addObject:aValue];
                    }];
                    value=items; 
                }
                [classObject setPorpertyValueForName:value PorpertyName:realPorperty];
            }
        }];
    }
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
    NSDictionary *dic=[ NSObject getProperty:object WithType:NO];
    jsonString =[[NSMutableString alloc]initWithString:[NSDictionary dictionaryConvertoString:dic]];
    return jsonString;
}
+(BOOL)isBaseType:(id)object
{
    if([object isKindOfClass:[NSString class]]
       &&![object isKindOfClass:[NSNumber class]])
    {
        return NO;
    }
    return YES;
    
}
-(void)setPorpertyValueForName:(id)value PorpertyName:(NSString *)porpertyName
{
    Ivar var= class_getInstanceVariable([self class],[[NSString stringWithFormat:@"_%@",porpertyName] UTF8String]);
    object_setIvar(self,var,value);
}
+(BOOL)isJsonType:(id)object
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
+(NSString *)getPorpertyTypeFromPorpertyName:(NSString *)name class:(Class)aclass
{
    Ivar var = class_getInstanceVariable(aclass,[[NSString stringWithFormat:@"_%@",name] UTF8String]);
    const char* typeEncoding =ivar_getTypeEncoding(var);
    NSString *stringType =  [NSString stringWithCString:typeEncoding encoding:NSUTF8StringEncoding];
    return stringType;
}

+(NSDictionary *)getProperty:(id)object WithType:(BOOL)withType
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
        if(withType)
        {
            NSString * dataType = [NSString stringWithCString:ivar_getTypeEncoding(thisValue) encoding:NSUTF8StringEncoding];
            propertyName=[NSString stringWithFormat:@"%@:%@",propertyName,dataType];
        }
        NSString *dicKey=[NSString stringWithFormat:@"%@",propertyName];
        if (propertyValue)
        {
            if([NSObject isJsonType:propertyValue])
            {
               [props setObject:propertyValue forKey:dicKey];
            }else
            {
                NSDictionary *property=[NSObject getProperty:propertyValue WithType:NO];
                [props setObject:property forKey:dicKey];
            }
            
        }
        else [props setObject:@"nil" forKey:dicKey];
    }
    free(properties);
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