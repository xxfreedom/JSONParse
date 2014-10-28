//
//  UserInfo.m
//  JSONParse
//
//  Created by sy on 14-10-28.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
-(void)initArrayPropertyItemClassMapTable
{
    _arrayPropertyItemClasses=nil;
}
-(void)initPerportyMapTable
{
    _propertyMapTable=@{@"SrealName":@"realName",@"SnickName":@"nickName",@"Sage":@"age",@"SID":@"ID"};
}
@end
