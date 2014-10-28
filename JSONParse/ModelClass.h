//
//  ModelClass.h
//  JSONParse
//
//  Created by sy on 14-10-17.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYModelObject.h"
@interface ModelClass : SYModelObject
@property (nonatomic,assign)int modelId;
@property (nonatomic,assign)float modelAddressId;
@property (nonatomic,copy)NSString *modelName;
@property (nonatomic,strong)NSArray *modelArray;
@property (nonatomic,strong)NSDictionary *modelDictionary;
@property (nonatomic,copy)NSNumber *modelNumber;
@property (nonatomic,strong)ModelClass* model;
@end
