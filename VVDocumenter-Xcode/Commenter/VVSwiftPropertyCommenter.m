//
//  VVSwiftPropertyCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 14-7-31.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

#import "VVSwiftPropertyCommenter.h"

@implementation VVSwiftPropertyCommenter

-(NSString *) document
{
    return [NSString stringWithFormat:@"%@/// <#Description#>", self.indent];
}

@end
