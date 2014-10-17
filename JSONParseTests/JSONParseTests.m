//
//  JSONParseTests.m
//  JSONParseTests
//
//  Created by sy on 14-10-16.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JSONParse.h"
#import "ModelClass.h"
@interface JSONParseTests : XCTestCase

@end

@implementation JSONParseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
-(void)testJson
{
    NSDictionary *dic = @{@"1":@"2",@"2":@"3",@"number":@(1),@"null":[NSNull null],@"emoji":@"🍉👨👩"};
    NSArray *array=@[@"1",@"2",@"3",@(1),[NSNull null]];
   id json= [JSONParse ObjectConvertToJson:dic];
    NSLog(@"json:%@",json);
    
    id object=[JSONParse JsonConvertToObject:json];
    NSLog(@"object:%@",object);
    
    NSString *dicJsonStr=[NSDictionary dictionaryConvertoString:dic];
    NSLog(@"DictionaryStr:%@",dicJsonStr);
    NSString *arrayJsonStr=[NSArray arrayConvertoString:array];
    NSLog(@"arrayStr:%@",arrayJsonStr);
    
    NSArray *comArray=@[@"1",@"2",@"3", @{@"1":@"2",@"2":@"3"}];
    NSDictionary *comDictionary=@{@"1":@"2",@"2":@"3",@"dic":@[@"1",@"2",@"3"]};
    
    NSLog(@"ComAarrayJson:%@",[NSArray arrayConvertoString:comArray]);
    NSLog(@"ComDictionaryJson:%@",[NSDictionary dictionaryConvertoString:comDictionary]);
}
-(void)testModelJsonString
{
    ModelClass *model=[[ModelClass alloc]init];
    model.modelId=1;
    model.modelAddressId=1.001;
    model.modelArray=@[@"1",@"2",@"3",@(1),[NSNull null]];
    model.modelName=@"model";
    model.modelNumber=@(12333);
    model.modelDictionary=@{@"1":@"2",@"2":@"3",@"number":@(1),@"null":[NSNull null],@"emoji":@"🍉👨👩"};
    
    ModelClass *model2=[[ModelClass alloc]init];
    model2.modelId=1;
    model2.modelAddressId=1.001;
    model2.modelArray=@[@"1",@"2",@"3",@(1),[NSNull null]];
    model2.modelName=@"model";
    model2.modelNumber=@(12333);
    model2.modelDictionary=@{@"1":@"2",@"2":@"3",@"number":@(1),@"null":[NSNull null],@"emoji":@"🍉👨👩"};
    
    model.model=model2;
    NSLog(@"%@",[ModelClass objectPropertyConvertoString:model]);
}
@end
