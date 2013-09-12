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
    NSString *removedFirstPart = [self.code vv_stringByReplacingRegexPattern:@"^\\s*(\\w+\\s)?NS_ENUM.*\\{" withString:@""];
    removedFirstPart = [removedFirstPart vv_stringByReplacingRegexPattern:@"^\\s*(\\w+\\s)?enum.*\\{" withString:@""];
    VVLog(@"String without first part - %@", removedFirstPart);
    NSString *removedEnd = [removedFirstPart vv_stringByReplacingRegexPattern:@"[}]$" withString:@""];
    VVLog(@"String without end - %@", removedEnd);
    
    NSArray *comp = [removedEnd componentsSeparatedByString:@","];
    VVLog(@"comp array - %@", comp);
    
    NSString *final = [NSString stringWithFormat:@"%@%@%@\n",[self startComment],
                       [self sinceComment],
                       [self endComment]];
    
    NSRegularExpression *ex = [NSRegularExpression regularExpressionWithPattern:@"^\\s*(\\w+\\s)?NS_ENUM.*\\{" options:0 error:nil];
    NSTextCheckingResult *res = [ex firstMatchInString:self.code options:0 range:NSMakeRange(0, self.code.length)];
    
    final = [final stringByAppendingString:[self.code substringWithRange:[res rangeAtIndex:0]]];
    final = [final stringByAppendingString:@"\n"];
    
    for (NSString *co in comp) {
        NSString *tem = [NSString stringWithFormat:@"%@%@%@%@",    [self startComment],
                                                        [self sinceComment],
                                                        [self endComment],
                                                        co];
        if (co != [comp lastObject]) {
            tem = [tem stringByAppendingString:@",\n"];
        }
        final = [final stringByAppendingString:tem];
    }
   // final = [final stringByAppendingString:@"};"];
    
    return final;
}

@end
