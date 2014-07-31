//
//  VVSwiftFunctionCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 14-7-30.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

#import "VVSwiftFunctionCommenter.h"
#import "VVArgument.h"
#import "NSString+VVTextGetter.h"
#import "VVTextResult.h"

@implementation VVSwiftFunctionCommenter
-(void) captureReturnType
{
    VVTextResult *funcParenthesesResult = [self.code vv_textResultMatchPartWithPairOpenString:@"(" closeString:@")" currentLocation:0];
    NSString * funcSignatureWithoutParams = [self.code stringByReplacingCharactersInRange:funcParenthesesResult.range withString:@""];
    
    if ([funcSignatureWithoutParams vv_matchesPatternRegexPattern:@"\\s*->\\s*\\(?(\\Void?|\\(\\s*\\))\\)?\\s*[{]"]) {
        self.hasReturn = NO;
    } else if ([funcSignatureWithoutParams vv_matchesPatternRegexPattern:@"s*->\\s*"]) {
        self.hasReturn = YES;
    } else if ([funcSignatureWithoutParams vv_matchesPatternRegexPattern:@"^\\s*(.*\\s+)?init\\s*"]) {
        self.hasReturn = YES;
    } else {
        self.hasReturn = NO;
    }
}

-(void) captureParameters
{
    NSArray * braceGroups = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\((.*)\\)"];
    if (braceGroups.count > 0) {
        NSString *content = braceGroups[0];
        NSString *trimmed = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmed.length != 0) {
            [self parseSwiftArgumentsInputArgs:trimmed];
        }
    }
}

-(void) parseSwiftArgumentsInputArgs:(NSString *)rawArgsCode
{
    [self.arguments removeAllObjects];
    if (rawArgsCode.length == 0) {
        return;
    }
    
    NSString *removedUnwantComma = [rawArgsCode vv_stringByReplacingRegexPattern:@"([{(].*?[^\\)}],.*?[)}])" withString:@""];
    
    NSArray *argumentStrings = [removedUnwantComma componentsSeparatedByString:@","];
    for (__strong NSString *argumentString in argumentStrings) {
        VVArgument *arg = [[VVArgument alloc] init];
        argumentString = [argumentString vv_stringByReplacingRegexPattern:@"=\\s*\\w*" withString:@""];
        argumentString = [argumentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        argumentString = [argumentString vv_stringByReplacingRegexPattern:@"\\s+" withString:@" "];
        NSMutableArray *tempArgs = [[argumentString componentsSeparatedByString:@":"] mutableCopy];
        if (tempArgs.count == 1) { //There is no ":", it is not a arg
            continue;
        }
        
        NSString *firstPart = [[tempArgs firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([firstPart rangeOfString:@" "].location != NSNotFound) {
            arg.name = [[[firstPart componentsSeparatedByString:@" "] lastObject] vv_stringByReplacingRegexPattern:@"#" withString:@""];
        } else {
            arg.name = [firstPart vv_stringByReplacingRegexPattern:@"#" withString:@""];
        }
        
        VVLog(@"arg name: %@", arg.name);
        
        [self.arguments addObject:arg];
    }
}

-(NSString *) document
{
    [self captureReturnType];
    [self captureParameters];
    
    return [super documentForSwift];
}
@end
