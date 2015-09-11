//
//  VVSwiftFunctionCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 14-7-30.
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

#import "VVSwiftFunctionCommenter.h"
#import "VVArgument.h"
#import "NSString+VVTextGetter.h"
#import "VVTextResult.h"

@implementation VVSwiftFunctionCommenter
-(void) captureReturnType
{
    VVTextResult *funcParenthesesResult = [self.code vv_textResultMatchPartWithPairOpenString:@"(" closeString:@")" currentLocation:0];
    NSString * funcSignatureWithoutParams = [self.code stringByReplacingCharactersInRange:funcParenthesesResult.range withString:@" "];
    
    if ([funcSignatureWithoutParams vv_matchesPatternRegexPattern:@"\\s+(throws|rethrows)\\s+"]) {
        self.hasThrows = YES;
    }
    
    if ([funcSignatureWithoutParams vv_matchesPatternRegexPattern:@"\\s*->\\s*\\(?(\\Void?|\\(\\s*\\))\\)?\\s*[{]"]) {
        self.hasReturn = NO;
    } else if ([funcSignatureWithoutParams vv_matchesPatternRegexPattern:@"s*->\\s*"]) {
        self.hasReturn = YES;
    } else if ([funcSignatureWithoutParams vv_matchesPatternRegexPattern:@"^\\s*(.*\\s+)?(init|subscript)\\s*"]) {
        self.hasReturn = YES;
    } else {
        self.hasReturn = NO;
    }
}

-(void) captureParameters
{
    VVTextResult *funcParenthesesResult = [self.code vv_textResultMatchPartWithPairOpenString:@"(" closeString:@")" currentLocation:0];
    NSArray * braceGroups = [funcParenthesesResult.string vv_stringsByExtractingGroupsUsingRegexPattern:@"\\((.*)\\)"];
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
    
    NSString *removedUnwantComma = [rawArgsCode vv_stringByReplacingRegexPattern:@"[{].*?[^}],.*?[)}]" withString:@""];
    
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
