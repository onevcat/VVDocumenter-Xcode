//
//  VVDocumenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVDocumenter.h"
#import "NSString+VVSyntax.h"
#import "VVCommenter.h"

@interface VVDocumenter()

@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL isEnum;
@property (nonatomic, assign) BOOL isSwiftEnum;

@end

@implementation VVDocumenter

-(instancetype) initWithCode:(NSString *)code
{
    self = [super init];
    if (self) {
        NSString *trimmed = [[code vv_stringByReplacingRegexPattern:@"\\s*(\\(.*\?\\))\\s*" withString:@"$1"]
                             vv_stringByReplacingRegexPattern:@"\\s*\n\\s*"           withString:@" "];
        _isEnum = [trimmed vv_isEnum];
        _isSwiftEnum = [trimmed vv_isSwiftEnum];
        if (_isEnum || _isSwiftEnum) {
            _code = code;
        } else {
            //Trim the space around the braces
            //Then trim the new line character
            _code = trimmed;
        }
    }
    return self;
}

-(NSString *) baseIndentation
{
    NSArray *matchedSpaces = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"^(\\s*)"];
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
    
    VVBaseCommenter *commenter = nil;
    
    if (self.isEnum) {    
        commenter = [[VVEnumCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if (self.isSwiftEnum) {
        commenter = [[VVSwiftEnumCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode vv_isProperty]) {
        commenter = [[VVPropertyCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode vv_isCFunction]) {
        commenter = [[VVFunctionCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode vv_isMacro]) {
        commenter = [[VVMacroCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode vv_isStruct]) {
        commenter = [[VVStructCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode vv_isUnion]) {
        commenter = [[VVStructCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode vv_isObjCMethod]) {
        commenter = [[VVMethodCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode vv_isSwiftFunction]) {
        commenter = [[VVSwiftFunctionCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode vv_isSwiftProperty]) {
        commenter = [[VVSwiftPropertyCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else {
        commenter = [[VVVariableCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    }

    if ([commenter shouldComment]) {
        return [commenter document];
    } else {
        return nil;
    }
}



@end
