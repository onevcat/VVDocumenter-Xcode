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
    if ([self.code vv_matchesPatternRegexPattern:@"\\("]) {
        [self parseArguments];
    }
}

-(NSString *) document
{
    [self captureReturnType];
    [self captureParameters];
    
    return [super document];
}

@end
