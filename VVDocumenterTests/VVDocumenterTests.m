//
//  VVDocumenterTests.m
//  VVDocumenterTests
//
//  Created by 王 巍 on 13-7-19.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VVDocumenter.h"
#import "NSString+VVSyntax.h"
#import "VVTestHelper.h"

@interface VVDocumenterTests : SenTestCase
@property NSDictionary *testCaseDic;
@end

@implementation VVDocumenterTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"VVMethodTestsCode" ofType:@"plist"];
    self.testCaseDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    self.testCaseDic = nil;
    [super tearDown];
}

-(void) testDocument
{
    [self.testCaseDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *cases, BOOL *stop) {
        [cases enumerateObjectsUsingBlock:^(NSDictionary *testDic, NSUInteger idx, BOOL *stop) {
            NSString *source = testDic[@"source"];
            NSString *uniform = testDic[@"uniform"];
            NSString *result = testDic[@"result"];
            
            STAssertNotNil(source, @"Test source code should exist.");
            STAssertNotNil(uniform, @"Test uniform code should exist.");
            STAssertNotNil(result, @"Test result code should exist.");
            
            STAssertEqualObjects([source vv_stringByConvertingToUniform], uniform, @"Source should be converted to uniform format corrctly.");
            
            STAssertTrue([VVTestHelper performSyntaxMethod:key onString:uniform], @"This uniform code should be %@",key);
            
            NSArray *otherTypeStrings = [VVTestHelper arrayOfExceptCodeType:key];
            for (NSString *type in otherTypeStrings) {
                STAssertFalse([VVTestHelper performSyntaxMethod:type onString:uniform], @"This uniform code should not be %@",type);
            }
            
            VVDocumenter *documenter = [[VVDocumenter alloc] initWithCode:uniform];
            STAssertEqualObjects([documenter document], result, @"Result should be correct");
            
        }];
    }];
}



@end
