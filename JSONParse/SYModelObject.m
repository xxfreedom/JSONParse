//
//  SYModelObject.m
//  JSONParse
//
//  Created by sy on 14-10-28.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "SYModelObject.h"

@implementation SYModelObject

-(id)init
{
    self=[super init];
    if(self)
    {
        [self initPerportyMapTable];
    }
    return self;
}
-(void)initPerportyMapTable
{
    
}
-(void)initArrayPropertyItemClassMapTable
{
    
}
-(NSDictionary *)getPropertyMapTable
{
    return _propertyMapTable;
}
-(NSDictionary *)getArrayPropertyItemClassMapTable
{
    return _arrayPropertyItemClasses;
}
@end
