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
    NSArray * matchedTypes = [self.code stringsByExtractingGroupsUsingRegexPattern:@"^\\s*[+-]\\s*\\(([^\\(\\)]*)\\)"];

    if (matchedTypes.count == 1) {
        NSString *typeString = [matchedTypes[0] stringByReplacingRegexPattern:@"[\\s*;.*]" withString:@""];
        VVLog(@"type: %@",typeString);
        if (![typeString isEqualToString:@"void"] && ![typeString isEqualToString:@"IBAction"]) {
            self.hasReturn = YES;
        }
    }
}

-(void) captureParameters
{
    NSArray * matchedParams = [self.code stringsByExtractingGroupsUsingRegexPattern:@"\\:\\(([^\\(]+)\\)(\\S+)"];
    VVLog(@"matchedParams: %@",matchedParams);
    for (int i = 0; i < matchedParams.count - 1; i = i + 2) {
        VVArgument *arg = [[VVArgument alloc] init];
        arg.type = [matchedParams[i] stringByReplacingRegexPattern:@"[\\s*;.*]" withString:@""];
        arg.name = [matchedParams[i + 1] stringByReplacingRegexPattern:@"[\\s*;.*]" withString:@""];
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
