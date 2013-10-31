//
//  VVMethodCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVMethodCommenter.h"
#import "VVArgument.h"

@implementation VVMethodCommenter

-(void) captureReturnType
{
    NSArray * matchedTypes = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"^\\s*[+-]\\s*\\(([^\\(\\)]*)\\)"];

    if (matchedTypes.count == 1) {
        if (![matchedTypes[0] vv_matchesPatternRegexPattern:@"^\\s*void\\s*[^*]*\\s*$"] &&
            ![matchedTypes[0] vv_matchesPatternRegexPattern:@"^\\s*IBAction\\s*$"]) {
            self.hasReturn = YES;
        }
    }
}

-(void) captureParameters
{
    NSArray * matchedParams = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\:\\(([^:]+)\\)(\\w+)"];
    VVLog(@"matchedParams: %@",matchedParams);
    for (int i = 0; i < (int)matchedParams.count - 1; i = i + 2) {
        VVArgument *arg = [[VVArgument alloc] init];
        arg.type = [matchedParams[i] vv_stringByReplacingRegexPattern:@"[\\s*;.*]" withString:@""];
        arg.name = [matchedParams[i + 1] vv_stringByReplacingRegexPattern:@"[\\s*;.*]" withString:@""];
        [self.arguments addObject:arg];
    }
}

-(NSString *) document
{
    [self captureReturnType];
    [self captureParameters];
    
    return [super document];
}

@end
