//
//  SYModelObject.h
//  JSONParse
//
//  Created by sy on 14-10-28.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYModelObject : NSObject
{
    NSDictionary *_propertyMapTable;
    NSDictionary *_arrayPropertyItemClasses;
}
-(NSDictionary *)getPropertyMapTable;
-(NSDictionary *)getArrayPropertyItemClassMapTable;
-(void)initPerportyMapTable;
-(void)initArrayPropertyItemClassMapTable;
@end
