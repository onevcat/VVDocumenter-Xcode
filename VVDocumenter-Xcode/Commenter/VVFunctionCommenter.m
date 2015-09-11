//
//  VVFunctionCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
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
    NSArray * braceGroups = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\(([^\\^].*?)\\)(?:__attribute__\\(\\(.*\\)\\))?"];
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
    
    return [super documentForC];
}

@end
