//
//  VVMethodTests.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 14-1-30.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VVDocumenter.h"
#import "NSString+VVSyntax.h"
#import "VVTestHelper.h"

@interface VVMethodTests : SenTestCase
@property NSArray *testCases;
@end

@implementation VVMethodTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"VVMethodTestsCode" ofType:@"plist"];
    self.testCases = [NSArray arrayWithContentsOfFile:path];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void) testMethod
{
    [self.testCases enumerateObjectsUsingBlock:^(NSDictionary *testDic, NSUInteger idx, BOOL *stop) {
        NSString *source = testDic[@"source"];
        NSString *uniform = testDic[@"uniform"];
        NSString *result = testDic[@"result"];
        
        STAssertNotNil(source, @"Test source code should exist.");
        STAssertNotNil(uniform, @"Test uniform code should exist.");
        STAssertNotNil(result, @"Test result code should exist.");
        
        STAssertEqualObjects([source vv_stringByConvertingToUniform], uniform, @"Source should be converted to uniform format corrctly.");
        
        STAssertEqualObjects([source vv_stringByConvertingToUniform], uniform, @"Source should be converted to uniform format corrctly.");
        
        NSString *typeString = @"vv_isObjCMethod";
        STAssertTrue([VVTestHelper performSyntaxMethod:typeString onString:uniform], @"This uniform code should be Objc");
        
        NSArray *otherTypeStrings = [VVTestHelper arrayOfExceptCodeType:typeString];
        for (NSString *type in otherTypeStrings) {
            STAssertFalse([VVTestHelper performSyntaxMethod:type onString:uniform], @"This uniform code should not be %@",type);
        }
        
        VVDocumenter *documenter = [[VVDocumenter alloc] initWithCode:uniform];
        STAssertEqualObjects(result, [documenter document], @"Result should be correct");
        
    }];
}



@end
