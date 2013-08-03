//
//  VVBaseCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVBaseCommenter.h"
#import "VVArgument.h"
#import "VVDocumenterSetting.h"

@interface VVBaseCommenter()
@property (nonatomic, copy) NSString *space;
@end

@implementation VVBaseCommenter
-(id) initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    self = [super init];
    if (self) {
        self.indent = indent;
        self.code = code;
        self.arguments = [NSMutableArray array];
        self.space = [[VVDocumenterSetting defaultSetting] spacesString];
    }
    return self;
}

-(NSString *) startComment
{
    return [NSString stringWithFormat:@"%@/**\n%@ *%@<#%@#>\n",self.indent,self.indent,self.space,@"Description"];
}

-(NSString *) argumentsComment
{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    for (VVArgument *arg in self.arguments) {
        if (result.length == 0) {
            [result appendFormat:@"%@ *\n",self.indent];
        }
        [result appendFormat:@"%@ *%@@param%@%@%@<#%@ description#>\n",self.indent,self.space,self.space,arg.name,self.space,arg.name];
    }
    return result;
}

-(NSString *) returnComment

{
    if (!self.hasReturn) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@ *\n%@ *%@@return%@<#return value description#>\n",self.indent,self.indent,self.space,self.space];
    }
}

-(NSString *) endComment
{
    return [NSString stringWithFormat:@"%@ */",self.indent];
}

-(NSString *) document
{
    return [NSString stringWithFormat:@"%@%@%@%@",[self startComment],
                                                  [self argumentsComment],
                                                  [self returnComment],
                                                  [self endComment]];
}

-(void) parseArguments
{
    [self.arguments removeAllObjects];
    NSArray * braceGroups = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\(([^\\(\\)]*)\\)"];
    if (braceGroups.count > 0) {
        NSString *argumentGroupString = braceGroups[0];
        NSArray *argumentStrings = [argumentGroupString componentsSeparatedByString:@","];
        for (NSString *argumentString in argumentStrings) {
            VVArgument *arg = [[VVArgument alloc] init];
            argumentString = [argumentString vv_stringByReplacingRegexPattern:@"\\s+$" withString:@""];
            argumentString = [argumentString vv_stringByReplacingRegexPattern:@"\\s+" withString:@" "];
            NSMutableArray *tempArgs = [[argumentString componentsSeparatedByString:@" "] mutableCopy];
            while ([[tempArgs lastObject] isEqualToString:@" "]) {
                [tempArgs removeLastObject];
            }
            arg.name = [tempArgs lastObject];

            [tempArgs removeLastObject];
            arg.type = [tempArgs componentsJoinedByString:@" "];
            
            VVLog(@"arg type: %@", arg.type);
            VVLog(@"arg name: %@", arg.name);
            
            [self.arguments addObject:arg];
        }
    }

}
@end
