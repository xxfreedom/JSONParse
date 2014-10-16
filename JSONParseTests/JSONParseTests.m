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
    NSDictionary *dic = @{@"1":@"2",@"2":@"3"};
    NSArray *array=@[@"1",@"2",@"3"];
   id json= [JSONParse ObjectCovertToJson:dic];
    NSLog(@"json:%@",json);
    
    NSString *dicJsonStr=[NSDictionary dictionaryCoverToString:dic];
    NSLog(@"jsonStr:%@",dicJsonStr);
    NSString *arrayJsonStr=[NSArray arrayCoverToString:array];
    NSLog(@"arrayStr:%@",arrayJsonStr);
}
@end
