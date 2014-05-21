//
//  Argument.m
//  CommentTest
//
//  Created by 王 巍 on 13-7-19.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVArgument.h"

@implementation VVArgument

-(void)setType:(NSString *)type
{
    if (type != _type) {
       _type = [[[type vv_stringByReplacingRegexPattern:@"&$" withString:@""]
                       vv_stringByReplacingRegexPattern:@"\\s*\\*$" withString:@""]
                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

-(void)setName:(NSString *)name
{
    if (name != _name) {
        _name = [[[[[[[name vv_stringByReplacingRegexPattern:@"\\(|\\)" withString:@""]
                            vv_stringByReplacingRegexPattern:@"^&" withString:@""]
                            vv_stringByReplacingRegexPattern:@"^\\*+" withString:@""]
                            vv_stringByReplacingRegexPattern:@"\\[.*$" withString:@""]
                            vv_stringByReplacingRegexPattern:@",$" withString:@""]
                            vv_stringByReplacingRegexPattern:@";$" withString:@""]
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@< type: %@, name: %@>", self.class, self.type, self.name];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if ([other isKindOfClass:self.class]) {
        return [((VVArgument *)other).type isEqualToString:self.type]
            && [((VVArgument *)other).name isEqualToString:self.name];
    }
    return NO;
}

@end
