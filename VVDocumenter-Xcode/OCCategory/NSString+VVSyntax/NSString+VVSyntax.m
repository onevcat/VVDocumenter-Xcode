//
//  NSString+VVSyntax.m
//  CommentTest
//
//  Created by 王 巍 on 13-7-18.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "NSString+VVSyntax.h"

@implementation NSString (VVSyntax)
-(NSString *) vv_stringByConvertingToUniform
{
    return [[[self vv_stringByReplacingRegexPattern:@"\\s*\\("    withString:@"("]
                   vv_stringByReplacingRegexPattern:@"\\)\\s*"    withString:@")"]
                   vv_stringByReplacingRegexPattern:@"\\s*\n\\s*" withString:@" "];
}

-(NSString *) vv_stringByTrimEndSpaces
{
    return [self vv_stringByReplacingRegexPattern:@"\\s*\n" withString:@"\n"];
}

-(BOOL) vv_isObjCMethod
{
    return [self vv_matchesPatternRegexPattern:@"^\\s*[+-]"];
}

-(BOOL) vv_isCFunction
{
    return ![self vv_isEnum] &&
           ![self vv_isMacro] &&
           ![self vv_isObjCMethod] &&
           ![self vv_isProperty] &&
           ![self vv_isComplieKeyword] &&
           ![self vv_isSwiftFunction] &&
           ![self vv_isSwiftEnum] &&
           ![self vv_isSwiftProperty] &&
           [self vv_matchesPatternRegexPattern:@".+\\s+.+\\("];
}

-(BOOL) vv_isProperty
{
	return [self vv_matchesPatternRegexPattern:@"^\\s*\\@property"];
}

-(BOOL) vv_isMacro
{
    return [self vv_matchesPatternRegexPattern:@"^\\s*\\#define"];
}

-(BOOL) vv_isStruct
{
    return [self vv_matchesPatternRegexPattern:@"^\\s*(\\w+\\s)?struct.*\\{"];
}

-(BOOL) vv_isEnum
{
    return [self vv_matchesPatternRegexPattern:@"^\\s*(\\w+\\s+)?NS_(ENUM|OPTIONS)\\b"];
}

-(BOOL) vv_isUnion
{
    return [self vv_matchesPatternRegexPattern:@"^\\s*(\\w+\\s)?union.*\\{"];
}

-(BOOL) vv_isComplieKeyword
{
    return ![self vv_isProperty] && [self vv_matchesPatternRegexPattern:@"^\\s*\\@"];
}

-(BOOL) vv_isSwiftFunction
{
    return ![self vv_isObjCMethod] && ![self vv_isSwiftProperty] && [self vv_matchesPatternRegexPattern:@"^\\s*(.*\\s+)?(func\\s+)|(init|deinit|subscript)"];
}

-(BOOL) vv_isSwiftEnum
{
    return [self vv_matchesPatternRegexPattern:@"^\\s*(.*\\s+)?enum\\s+"];
}

-(BOOL) vv_isSwiftProperty
{
    // `let`/`var` can be in swift func, but `(` appear before `let`/`var` only
    // happens when `private(set)` or `internal(set)` is used
    return [self vv_matchesPatternRegexPattern:@"^\\s*([^(]*?)(((\\s*let|var\\s*)\\s+)|(\\(\\s*set\\s*\\)))"];
}

@end
