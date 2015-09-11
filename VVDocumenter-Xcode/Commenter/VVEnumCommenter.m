//
//  VVEnumCommenter.m
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

#import "VVEnumCommenter.h"

@implementation VVEnumCommenter

- (NSString *)document {
    //Regular comment documentation
    NSString *finalString = [NSString stringWithFormat:@"%@%@%@", [self startComment],
                                                                  [self sinceComment],
                                                                  [self endComment]];

    if (![finalString hasSuffix:@"\n"]) {
        finalString = [finalString stringByAppendingString:@"\n"];
    }

    // Grab everything from the start of the line to the opening brace, which
    // may be on a different line.
    NSString *enumDefinePattern = @"^\\s*(\\w+\\s+)?NS_(ENUM|OPTIONS)[\\s\\S]*?\\{";
    
    NSRegularExpression *enumDefineExpression = [NSRegularExpression regularExpressionWithPattern:enumDefinePattern options:0 error:nil];
    NSTextCheckingResult *enumDefineResult = [enumDefineExpression firstMatchInString:self.code options:0 range:NSMakeRange(0, self.code.length)];
    
    finalString = [finalString stringByAppendingString:[self.code substringWithRange:[enumDefineResult rangeAtIndex:0]]];
    finalString = [finalString stringByAppendingString:@"\n"];
    
    NSString *endPattern = @"\\}\\s*;";
    NSString *enumPartsString = [[self.code vv_stringByReplacingRegexPattern:enumDefinePattern withString:@""]
                                            vv_stringByReplacingRegexPattern:endPattern        withString:@""];
    NSArray *enumParts = [enumPartsString componentsSeparatedByString:@","];
    
    for (NSString *part in enumParts) {
        NSString *trimmedPart = [part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //Only append when there is a enum define. (In case of the last comma, followed no define)
        if (trimmedPart.length != 0) {
            NSString *temp = [NSString stringWithFormat:@"%@%@%@", [self startCommentWithDescriptionTag:@""],
                              [self sinceComment],
                              [self endComment]];

            if ([temp hasSuffix:@"\n"]) {
                // comment has a newline suffix, so trimmedPart will go on
                // the next line
                temp = [temp stringByAppendingString:trimmedPart];
            } else {
                // comment does not have a newline suffix, so trimmedPart
                // needs to be moved to the next line
                temp = [temp stringByAppendingFormat:@"\n%@", trimmedPart];
            }

            if (part != [enumParts lastObject]) {
                temp = [temp stringByAppendingString:@",\n"];
            } else {
                // since trimmedPart was used there is no trailing newline
                temp = [temp stringByAppendingString:@"\n"];
            }
            finalString = [finalString stringByAppendingString:temp];
        }
    }

    return [finalString stringByAppendingString:@"};"];
}

@end
