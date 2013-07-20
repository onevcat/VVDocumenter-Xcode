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
    STAssertTrue([arg.type isEqualToString:@"int"], @"%@",arg.type);
    
    arg.type = @"char *";
    STAssertTrue([arg.type isEqualToString:@"char"], @"%@",arg.type);
    
    arg.type = @"char *";
    STAssertTrue([arg.type isEqualToString:@"char"], @"%@",arg.type);
}

- (void) testArgumentName
{
    VVArgument *arg = [[VVArgument alloc] init];
    
    arg.name = @"*argv[]";
    STAssertTrue([arg.name isEqualToString:@"argv"], @"%@",arg.name);
    
    arg.name = @"**a";
    STAssertTrue([arg.name isEqualToString:@"a"], @"%@",arg.name);
    
}



@end
