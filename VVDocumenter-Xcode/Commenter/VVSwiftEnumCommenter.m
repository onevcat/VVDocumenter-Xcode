//
//  VVSwiftEnumCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 14-7-30.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

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
