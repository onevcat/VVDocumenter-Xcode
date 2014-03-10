//
//  SyntaxTests.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-19.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "SyntaxTests.h"
#import "VVTestHelper.h"
#import "NSString+VVSyntax.h"

@interface SyntaxTests()

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
    NSArray *boolResult = @[@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isObjCMethod] == [boolResult[i] boolValue], @"%@ should %@ be a ObjC method", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsCFunction {
    NSArray *boolResult = @[@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isCFunction] == [boolResult[i] boolValue], @"%@ should %@ be a C function", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsProperty {
    NSArray *boolResult = @[@NO,@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isProperty] == [boolResult[i] boolValue], @"%@ should %@ be a property", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsMacro {
    NSArray *boolResult = @[@NO,@NO,@NO,@YES,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isMacro] == [boolResult[i] boolValue], @"%@ should %@ be a macro", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsStruct {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@YES,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isStruct] == [boolResult[i] boolValue], @"%@ should %@ be a struct", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsEnum {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@YES,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isEnum] == [boolResult[i] boolValue], @"%@ should %@ be a enum", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsUnion {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@YES,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isUnion] == [boolResult[i] boolValue], @"%@ should %@ be a union", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsCompileKeyword {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@YES];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            XCTAssertTrue([result vv_isComplieKeyword] == [boolResult[i] boolValue], @"%@ should %@ be a complie keyword", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

@end
