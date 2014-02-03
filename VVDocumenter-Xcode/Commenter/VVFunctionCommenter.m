//
//  VVFunctionCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVFunctionCommenter.h"
#import "VVArgument.h"

@implementation VVFunctionCommenter

-(void) captureReturnType
{
    NSArray *arr = [self.code componentsSeparatedByString:@"("];
    if (arr.count > 0 && (![arr[0] vv_matchesPatternRegexPattern:@"^\\s*void\\s*[^*]*\\s*\\w+$"] &&
                          ![arr[0] vv_matchesPatternRegexPattern:@"^\\w+\\svoid"])) {
        self.hasReturn = YES;
    }
}

-(void) captureParameters
{
    NSArray * braceGroups = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\(([^\\^].*)\\)"];
    if (braceGroups.count > 0) {
        [self parseArgumentsInputArgs:braceGroups[0]];
    }
    
    //Remove void arg in block
    NSArray *tempArray = [NSArray arrayWithArray:self.arguments];
    [tempArray enumerateObjectsUsingBlock:^(VVArgument *arg, NSUInteger idx, BOOL *stop) {
        if ([arg.type isEqualToString:@""] && [arg.name isEqualToString:@"void"]) {
            [self.arguments removeObject:arg];
        }
    }];
}

-(NSString *) document
{
    [self captureReturnType];
    [self captureParameters];
    
    return [super document];
}

@end
