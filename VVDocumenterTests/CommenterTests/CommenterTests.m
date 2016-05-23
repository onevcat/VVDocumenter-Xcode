//
//  CommenterTests.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-20.
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
