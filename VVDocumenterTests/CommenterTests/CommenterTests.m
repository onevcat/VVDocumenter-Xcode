//
//  CommenterTests.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-20.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VVCommenter.h"

@interface CommenterTests : XCTestCase

@end

@implementation CommenterTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testArgumentType
{
    VVArgument *arg = [[VVArgument alloc] init];
    
    arg.type = @" int ";
    XCTAssertEqualObjects(arg.type, @"int", @"%@",arg.type);
    
    arg.type = @"char *";
    XCTAssertEqualObjects(arg.type, @"char", @"%@",arg.type);
    
    arg.type = @"NSString *";
    XCTAssertEqualObjects(arg.type, @"NSString", @"%@",arg.type);
}

- (void) testArgumentName
{
    VVArgument *arg = [[VVArgument alloc] init];
    
    arg.name = @"*argv[]";
    XCTAssertEqualObjects(arg.name, @"argv", @"%@",arg.name);
    
    arg.name = @"**a";
    XCTAssertEqualObjects(arg.name, @"a", @"%@",arg.name);
    
}

- (void) testArgumentEquals
{
    VVArgument *argA = [[VVArgument alloc] init];
    argA.name = @"a";
    argA.type = @"NSString";
    
    VVArgument *argB = [[VVArgument alloc] init];
    argB.name = @"b";
    argB.type = @"NSString";
    
    VVArgument *argC = [[VVArgument alloc] init];
    argC.name = @"a";
    argC.type = @"NSString";
    
    XCTAssertEqualObjects(argA, argA);
    XCTAssertNotEqualObjects(argA, argB);
    XCTAssertEqualObjects(argA, argC);
}

-(void) testParseArguments
{
    VVBaseCommenter *baseCommenter = [[VVFunctionCommenter alloc] initWithIndentString:@"" codeString:@""];
    baseCommenter.code = @"void dosomething( int x, int  y  );";
    [baseCommenter document];

    VVArgument *arg0 = [[VVArgument alloc] init];
    arg0.type = @"int";
    arg0.name = @"x";
    
    VVArgument *arg1 = [[VVArgument alloc] init];
    arg1.type = @"int";
    arg1.name = @"y";
    
    NSUInteger count = baseCommenter.arguments.count;
    XCTAssertEqual(count, (NSUInteger)2, @"There should be 2 args, %@", baseCommenter.arguments);
    XCTAssertEqualObjects(arg0, baseCommenter.arguments[0]);
    XCTAssertEqualObjects(arg1, baseCommenter.arguments[1]);
}

- (void) testParseVarArguments
{
    VVBaseCommenter *baseCommenter = [[VVFunctionCommenter alloc] initWithIndentString:@"" codeString:@""];
    baseCommenter.code = @"int main(int argc, char *argv[]) \n {";
    [baseCommenter document];

    VVArgument *arg0 = [[VVArgument alloc] init];
    arg0.type = @"int";
    arg0.name = @"argc";
    
    VVArgument *arg1 = [[VVArgument alloc] init];
    arg1.type = @"char";
    arg1.name = @"argv";
    
    NSUInteger count = baseCommenter.arguments.count;
    XCTAssertEqual(count, (NSUInteger)2, @"There should be 2 args, %@", baseCommenter.arguments);
    XCTAssertEqualObjects(arg0, baseCommenter.arguments[0]);
    XCTAssertEqualObjects(arg1, baseCommenter.arguments[1]);
}

- (void) testParseAttributedFunction
{
    VVBaseCommenter *baseCommenter = [[VVFunctionCommenter alloc] initWithIndentString:@"" codeString:@""];
    baseCommenter.code = @"void dosomething( int x ) __attribute__((const));";
    [baseCommenter document];
    
    VVArgument *arg0 = [[VVArgument alloc] init];
    arg0.type = @"int";
    arg0.name = @"x";
    
    NSUInteger count = baseCommenter.arguments.count;
    XCTAssertEqual(count, (NSUInteger)1, @"There should be one arg, %@", baseCommenter.arguments);
    XCTAssertEqualObjects(arg0, baseCommenter.arguments[0]);
}

@end
