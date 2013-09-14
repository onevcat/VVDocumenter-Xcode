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
    NSString *enumDefinePattern = @"^\\s*(\\w+\\s+)?NS_ENUM.*\\{";
    NSString *enumPartsString = [[self.code vv_stringByReplacingRegexPattern:enumDefinePattern withString:@""]
                                            vv_stringByReplacingRegexPattern:@"[}]$" withString:@""];

    NSArray *enumParts = [enumPartsString componentsSeparatedByString:@","];

    NSString *finalString = [NSString stringWithFormat:@"%@%@%@\n", [self startComment],
                                                                    [self sinceComment],
                                                                    [self endComment]];
    
    NSRegularExpression *ex = [NSRegularExpression regularExpressionWithPattern:enumDefinePattern options:0 error:nil];
    NSTextCheckingResult *res = [ex firstMatchInString:self.code options:0 range:NSMakeRange(0, self.code.length)];
    
    finalString = [finalString stringByAppendingString:[self.code substringWithRange:[res rangeAtIndex:0]]];
    finalString = [finalString stringByAppendingString:@"\n"];
    
    for (NSString *part in enumParts) {
        NSString *temp = [NSString stringWithFormat:@"%@%@%@%@", [self startComment],
                                                                 [self sinceComment],
                                                                 [self endComment],
                                                                 part];
        if (part != [enumParts lastObject]) {
            temp = [temp stringByAppendingString:@",\n"];
        }
        finalString = [finalString stringByAppendingString:temp];
    }

    return finalString;
}

@end
