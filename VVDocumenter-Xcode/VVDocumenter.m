//
//  VVDocumenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVDocumenter.h"
#import "NSString+PDRegex.h"
#import "NSString+VVSyntax.h"
#import "Commenter.h"

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

-(NSString *) baseIndentation
{
    NSArray *matchedSpaces = [self.code stringsByExtractingGroupsUsingRegexPattern:@"^(\\s*)"];
    if (matchedSpaces.count > 0) {
        return matchedSpaces[0];
    } else {
        return @"";
    }
}

-(NSString *) document
{
    NSString *trimCode = [self.code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *baseIndent = [self baseIndentation];
    
    BaseCommenter *commenter = nil;
    if ([trimCode isObjCMethod]) {
        NSLog(@"isObjCMethod");
        commenter = [[MethodCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isProperty]) {
        NSLog(@"isProperty");
        commenter = [[PropertyCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isCFunction]) {
        NSLog(@"isCFunction");
        commenter = [[FunctionCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isMacro]) {
        NSLog(@"isMacro");
        commenter = [[MacroCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isStruct]) {
        NSLog(@"isStruct");
        commenter = [[StructCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isUnion]) {
        NSLog(@"isUnion");
        commenter = [[StructCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isEnum]) {
        NSLog(@"isEnum");
        commenter = [[EnumCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else {
        NSLog(@"No match. Use VariableCommenter");
        commenter = [[VariableCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    }

    return [commenter document];
}



@end
