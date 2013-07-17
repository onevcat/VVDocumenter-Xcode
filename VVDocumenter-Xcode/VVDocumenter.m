//
//  VVDocumenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVDocumenter.h"
#import "NSString+PDRegex.h"

@interface VVDocumenter()

@property (nonatomic, copy) NSString *code;

@end

@implementation VVDocumenter

-(id) initWithCode:(NSString *)code
{
    self = [super init];
    if (self) {
        //Trim the space around the braces
        //Then trim the new line character
        self.code = [[code stringByReplacingRegexPattern:@"\\s*(\\(.*\?\\))\\s*" withString:@"$1"]
                           stringByReplacingRegexPattern:@"\\s*\n\\s*"           withString:@" "];
        
    }
    return self;
}

-(NSString *) document
{
    return self.code;
}
@end
