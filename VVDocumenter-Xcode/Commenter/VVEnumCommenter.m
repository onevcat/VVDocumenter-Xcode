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
    NSString *finalString = [NSString stringWithFormat:@"%@%@%@\n", [self startComment],
                                                                    [self sinceComment],
                                                                    [self endComment]];
    
    NSString *enumDefinePattern = @"^\\s*(\\w+\\s+)?NS_ENUM.*\\{";
    
    NSRegularExpression *enumDefineExpression = [NSRegularExpression regularExpressionWithPattern:enumDefinePattern options:0 error:nil];
    NSTextCheckingResult *enumDefineResult = [enumDefineExpression firstMatchInString:self.code options:0 range:NSMakeRange(0, self.code.length)];
    
    finalString = [finalString stringByAppendingString:[self.code substringWithRange:[enumDefineResult rangeAtIndex:0]]];
    finalString = [finalString stringByAppendingString:@"\n"];
    
    NSString *endPattern = @"\\}\\s*;";
    NSString *enumPartsString = [[self.code vv_stringByReplacingRegexPattern:enumDefinePattern withString:@""]
                                            vv_stringByReplacingRegexPattern:endPattern        withString:@""];
    NSArray *enumParts = [enumPartsString componentsSeparatedByString:@","];
    
    for (NSString *part in enumParts) {
        NSLog(@"%@",part);
        //Only append when there is a enum define. (In case of the last comma, followed no define)
        if ([part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0) {
            NSString *temp = [NSString stringWithFormat:@"%@%@%@%@", [self startComment],
                              [self sinceComment],
                              [self endComment],
                              part];
            if (part != [enumParts lastObject]) {
                temp = [temp stringByAppendingString:@",\n"];
            }
            NSLog(@"%@",temp);
            finalString = [finalString stringByAppendingString:temp];
        }
    }

    return [finalString stringByAppendingString:@"};"];
}

@end
