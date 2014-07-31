//
//  VVTextResult.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 14-7-31.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

#import "VVTextResult.h"

@implementation VVTextResult

-(instancetype) initWithRange:(NSRange)aRange string:(NSString *)aString

{
    self = [super init];
    if (self) {
        _range = aRange;
        _string = aString;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Location:%ld, Length:%ld, String:%@",self.range.location,self.range.length,self.string];
}

@end