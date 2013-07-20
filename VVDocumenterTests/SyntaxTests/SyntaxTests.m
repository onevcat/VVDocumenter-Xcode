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

@property (nonatomic, retain) NSArray* inputs;
@property (nonatomic, retain) NSArray* corrects;

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
            NSString *converted = [self.inputs[i][j] stringByConvertingToUniform];
            NSString *result = self.corrects[i][j];
            STAssertTrue([result isEqualToString:converted], @"%@ should be the same as %@", converted, result);
        }
    }
}

-(void) testIsObjCMethod {
    NSArray *boolResult = @[@YES,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            STAssertTrue([result isObjCMethod] == [boolResult[i] boolValue], @"%@ should %@ be a ObjC method", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsCFunction {
    NSArray *boolResult = @[@NO,@YES,@NO,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            STAssertTrue([result isCFunction] == [boolResult[i] boolValue], @"%@ should %@ be a C function", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsProperty {
    NSArray *boolResult = @[@NO,@NO,@YES,@NO,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            STAssertTrue([result isProperty] == [boolResult[i] boolValue], @"%@ should %@ be a property", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsMacro {
    NSArray *boolResult = @[@NO,@NO,@NO,@YES,@NO,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            STAssertTrue([result isMacro] == [boolResult[i] boolValue], @"%@ should %@ be a macro", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsStruct {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@YES,@NO,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            STAssertTrue([result isStruct] == [boolResult[i] boolValue], @"%@ should %@ be a struct", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsEnum {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@YES,@NO,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            STAssertTrue([result isEnum] == [boolResult[i] boolValue], @"%@ should %@ be a enum", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

-(void) testIsUnion {
    NSArray *boolResult = @[@NO,@NO,@NO,@NO,@NO,@NO,@YES,@NO];
    
    for (int i = 0; i < (int)[self.inputs count]; i++) {
        for (int j = 0; j < [self.inputs[i] count]; j++) {
            NSString *result = self.corrects[i][j];
            STAssertTrue([result isUnion] == [boolResult[i] boolValue], @"%@ should %@ be a union", result, [boolResult[i] boolValue] ? @"" : @"not");
        }
    }
}

@end
