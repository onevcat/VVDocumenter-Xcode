//
//  VVMacroCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVMacroCommenter.h"

@implementation VVMacroCommenter

-(void) captureReturnType
{
    self.hasReturn = YES;
}

-(void) captureParameters
{
    NSArray * braceGroups = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\(([^\\^][^\\(\\)]*)\\)"];
    if (braceGroups.count > 0) {
        [self parseArgumentsInputArgs:braceGroups[0]];
    }
}

-(NSString *) document
{
    [self captureReturnType];
    [self captureParameters];
    
    return [super document];
}

@end
