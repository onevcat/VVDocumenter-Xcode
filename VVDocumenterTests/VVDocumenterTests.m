//
//  VVDocumenterTests.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-19.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <XCTest/XCTest.h>
#import "VVDocumenter.h"
#import "NSString+VVSyntax.h"
#import "VVTestHelper.h"

#import "NSTextView+VVTextGetter.h"

@interface VVDocumenterTests : XCTestCase
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
            
            XCTAssertNotNil(source, @"Test source code should exist.");
            XCTAssertNotNil(uniform, @"Test uniform code should exist.");
            XCTAssertNotNil(result, @"Test result code should exist.");
            
            XCTAssertEqualObjects([source vv_stringByConvertingToUniform], uniform, @"Source should be converted to uniform format corrctly.");
            
            XCTAssertTrue([VVTestHelper performSyntaxMethod:key onString:uniform], @"This uniform code should be %@",key);
            
            NSArray *otherTypeStrings = [VVTestHelper arrayOfExceptCodeType:key];
            for (NSString *type in otherTypeStrings) {
                XCTAssertFalse([VVTestHelper performSyntaxMethod:type onString:uniform], @"This uniform code should not be %@",type);
            }
            
            VVDocumenter *documenter = nil;
            if ([key isEqualToString:@"vv_isSwiftEnum"]) {
                documenter = [[VVDocumenter alloc] initWithCode:source];
            } else {
                documenter = [[VVDocumenter alloc] initWithCode:uniform];
            }

            XCTAssertEqualObjects([documenter document], result, @"Result should be correct");
            
        }];
    }];
}

@end
