//
//  SyntaxTests.m
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
#import "VVTestHelper.h"
#import "NSString+VVSyntax.h"

@interface SyntaxTests : XCTestCase

@property (nonatomic, strong) NSArray* inputs;
@property (nonatomic, strong) NSArray* corrects;

@end

@implementation SyntaxTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    self.inputs = [VVTestHelper testCodes];
    self.corrects = [VVTestHelper uniformCodes];
    
}

- (void)tearDown
{
    // Tear-down code here.
    self.inputs = nil;
    self.corrects = nil;
    
    [super tearDown];
}


-(void) testStringByConvertingToUniform {
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *converted = [self.inputs[i][j] vv_stringByConvertingToUniform];
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result isEqualToString:converted], @"%@ should be the same as %@", converted, result);
        }
    }
}

-(void) testIsObjCMethod {
    NSArray *boolResult = @[@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isObjCMethod] == [boolResult[i] boolValue], @"%@ should %@ be a ObjC method", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsCFunction {
    NSArray *boolResult = @[@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isCFunction] == [boolResult[i] boolValue], @"%@ should %@ be a C function", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsProperty {
    NSArray *boolResult = @[@NO,@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isProperty] == [boolResult[i] boolValue], @"%@ should %@ be a property", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsMacro {
    NSArray *boolResult = @[@NO,@NO,@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isMacro] == [boolResult[i] boolValue], @"%@ should %@ be a macro", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsStruct {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isStruct] == [boolResult[i] boolValue], @"%@ should %@ be a struct", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsEnum {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isEnum] == [boolResult[i] boolValue], @"%@ should %@ be a enum", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsUnion {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isUnion] == [boolResult[i] boolValue], @"%@ should %@ be a union", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsCompileKeyword {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@YES,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isComplieKeyword] == [boolResult[i] boolValue], @"%@ should %@ be a complie keyword", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsSwiftFunction {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@YES,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isSwiftFunction] == [boolResult[i] boolValue], @"%@ should %@ be a swift function", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsSwiftEnum {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@YES,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isSwiftEnum] == [boolResult[i] boolValue], @"%@ should %@ be a swift enum", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsSwiftProperty {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@YES,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isSwiftProperty] == [boolResult[i] boolValue], @"%@ should %@ be a swift property", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsSwiftExtension {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@YES];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isSwiftExtension] == [boolResult[i] boolValue], @"%@ should %@ be a swift extension", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

@end
