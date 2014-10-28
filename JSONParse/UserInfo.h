//
//  UserInfo.h
//  JSONParse
//
//  Created by sy on 14-10-28.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "SYModelObject.h"
#import <UIKit/UIKit.h>
@interface UserInfo : SYModelObject
@property (nonatomic,copy)NSString *realName;
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,strong)NSNumber* ID;
@property (nonatomic,strong)NSNumber * age;
@end
