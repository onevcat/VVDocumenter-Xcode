//
//  CommenterTests.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-20.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "CommenterTests.h"
#import "VVCommenter.h"

@interface CommenterTests()
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

-(void) testParseArguments
{
    VVBaseCommenter *baseCommenter = [[VVBaseCommenter alloc] initWithIndentString:@"" codeString:@""];
    baseCommenter.code = @"void dosomething( int x, int  y  );";
    
    VVArgument *arg0 = [[VVArgument alloc] init];
    arg0.type = @"int";
    arg0.name = @"x";
    
    VVArgument *arg1 = [[VVArgument alloc] init];
    arg1.type = @"int";
    arg1.name = @"y";
    
    NSArray * braceGroups = [baseCommenter.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\(([^\\^][^\\(\\)]*)\\)"];
    if (braceGroups.count > 0) {
        [baseCommenter parseArgumentsInputArgs:braceGroups[0]];
    }
    
    NSUInteger count = baseCommenter.arguments.count;
    XCTAssertEqual(count, (NSUInteger)2, @"There should be 2 args, %@",baseCommenter.arguments);
    XCTAssertEqualObjects(arg0.type, [(VVArgument *)baseCommenter.arguments[0] type], @"%@ should be type %@", [(VVArgument *)baseCommenter.arguments[0] type], arg0.type);
    XCTAssertEqualObjects(arg1.type, [(VVArgument *)baseCommenter.arguments[1] type], @"%@ should be type %@", [(VVArgument *)baseCommenter.arguments[1] type], arg1.type);
    
    XCTAssertEqualObjects(arg0.name, [(VVArgument *)baseCommenter.arguments[0] name], @"%@ should be name %@", [(VVArgument *)baseCommenter.arguments[0] name], arg0.name);
    XCTAssertEqualObjects(arg1.name, [(VVArgument *)baseCommenter.arguments[1] name], @"%@ should be type %@", [(VVArgument *)baseCommenter.arguments[1] name], arg1.name);
    
    baseCommenter.code = @"int main(int argc, char *argv[]) \n {";
    arg0.type = @"int";
    arg0.name = @"argc";
    
    arg1.type = @"char";
    arg1.name = @"argv";
    
    braceGroups = [baseCommenter.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\(([^\\^][^\\(\\)]*)\\)"];
    if (braceGroups.count > 0) {
        [baseCommenter parseArgumentsInputArgs:braceGroups[0]];
    }
    count = baseCommenter.arguments.count;
    XCTAssertEqual(count, (NSUInteger)2, @"There should be 2 args, %@",baseCommenter.arguments);
    XCTAssertEqualObjects(arg0.type, [(VVArgument *)baseCommenter.arguments[0] type], @"%@ should be type %@", [(VVArgument *)baseCommenter.arguments[0] type], arg0.type);
    XCTAssertEqualObjects(arg1.type, [(VVArgument *)baseCommenter.arguments[1] type], @"%@ should be type %@", [(VVArgument *)baseCommenter.arguments[1] type], arg1.type);
    
    XCTAssertEqualObjects(arg0.name, [(VVArgument *)baseCommenter.arguments[0] name], @"%@ should be name %@", [(VVArgument *)baseCommenter.arguments[0] name], arg0.name);
    XCTAssertEqualObjects(arg1.name, [(VVArgument *)baseCommenter.arguments[1] name], @"%@ should be type %@", [(VVArgument *)baseCommenter.arguments[1] name], arg1.name);
    
}

@end
