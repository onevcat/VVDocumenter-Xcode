//
//  VVSwiftEnumCommenter.m
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

#import "VVSwiftEnumCommenter.h"
#import "VVArgument.h"

@implementation VVSwiftEnumCommenter

-(void) captureParameters
{
    NSString *normalizedCode = [self.code vv_stringByReplacingRegexPattern:@"\\s*\\n\\s*" withString:@"\n"];
    NSArray *lines = [normalizedCode componentsSeparatedByString:@"\n"];
    [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
        if ([line vv_matchesPatternRegexPattern:@"^case\\s+"]) {
            NSString * plainCase = [line vv_stringByReplacingRegexPattern:@"\\(.*?\\)" withString:@""];
            plainCase = [[plainCase vv_stringByReplacingRegexPattern:@"^case\\s+" withString:@""] vv_stringByReplacingRegexPattern:@"\\s+" withString:@""];
            NSArray *cases = [plainCase componentsSeparatedByString:@","];
            [cases enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
                NSString *plainName = [name vv_stringByReplacingRegexPattern:@"=\\s*.*$" withString:@""];
                if ([plainName hasPrefix:@"."]) {
                    return;
                }
                VVArgument *arg = [[VVArgument alloc] init];
                arg.name = plainName;
                [self.arguments addObject:arg];
            }];
        }
    }];
}

-(NSString *) document
{
    [self captureParameters];
    return [super documentForSwiftEnum];
}

@end
