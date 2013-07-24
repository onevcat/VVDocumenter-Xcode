//
//  VVBaseCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVBaseCommenter.h"
#import "VVArgument.h"

@implementation VVBaseCommenter

-(id) initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    self = [super init];
    if (self) {
        self.indent = indent;
        self.code = code;
        self.arguments = [NSMutableArray array];
    }
    return self;
}

-(NSString *) startComment
{
    return [NSString stringWithFormat:@"/// \\brief <#%@#>\n///\n",@"Description"];
}

-(NSString *) argumentsComment
{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    for (VVArgument *arg in self.arguments) {
        [result appendFormat:@"/// \\param %@ <#%@ description#>\n",arg.name,arg.name];
    }
    return result;
}

-(NSString *) returnComment

{
    if (!self.hasReturn) {
        return @"/// \\return void";
    } else {
        return @"/// \\return <#return value description#>";
    }
}

-(NSString *) endComment
{
    return @"";
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
    NSArray * braceGroups = [self.code stringsByExtractingGroupsUsingRegexPattern:@"\\(([^\\(\\)]*)\\)"];
    if (braceGroups.count > 0) {
        NSString *argumentGroupString = braceGroups[0];
        NSArray *argumentStrings = [argumentGroupString componentsSeparatedByString:@","];
        for (NSString *argumentString in argumentStrings) {
            VVArgument *arg = [[VVArgument alloc] init];
            argumentString = [argumentString stringByReplacingRegexPattern:@"\\s+$" withString:@""];
            argumentString = [argumentString stringByReplacingRegexPattern:@"\\s+" withString:@" "];
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
