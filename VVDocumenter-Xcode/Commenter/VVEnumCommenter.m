//
//  VVEnumCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

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
            NSString *temp = [NSString stringWithFormat:@"%@%@%@", [self startComment],
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
