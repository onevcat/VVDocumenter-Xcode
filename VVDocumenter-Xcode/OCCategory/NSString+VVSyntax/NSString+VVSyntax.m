//
//  NSString+VVSyntax.m
//  CommentTest
//
//  Created by 王 巍 on 13-7-18.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "NSString+VVSyntax.h"
#import "NSString+PDRegex.h"

@implementation NSString (VVSyntax)

-(NSString *) stringByConvertingToUniform
{
    return [[self stringByReplacingRegexPattern:@"\\s*(\\(.*\?\\))\\s*" withString:@"$1"]
                  stringByReplacingRegexPattern:@"\\s*\n\\s*"           withString:@" "];
}

-(BOOL) isObjCMethod
{
    return [self matchesPatternRegexPattern:@"^\\s*[+-]"];
}

-(BOOL) isCFunction
{
    return ![self isMacro] && ![self isObjCMethod] && ![self isProperty] && [self matchesPatternRegexPattern:@".+\\s+.+\\("];
}

-(BOOL) isProperty
{
	return [self matchesPatternRegexPattern:@"^\\s*\\@property"];
}

-(BOOL) isMacro
{
    return [self matchesPatternRegexPattern:@"^\\s*\\#define"];
}

-(BOOL) isStruct
{
    return [self matchesPatternRegexPattern:@"^\\s*(\\w+\\s)?struct.*\\{"];
}

-(BOOL) isEnum
{
    return [self matchesPatternRegexPattern:@"^\\s*(\\w+\\s)?enum.*\\{"];
}

-(BOOL) isUnion
{
    return [self matchesPatternRegexPattern:@"^\\s*(\\w+\\s)?union.*\\{"];
}

@end
