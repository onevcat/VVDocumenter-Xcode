//
//  VVBaseCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "VVBaseCommenter.h"
#import "VVArgument.h"
#import "VVDocumenterSetting.h"
#import "NSString+VVSyntax.h"
#import "VVProject.h"

@interface VVBaseCommenter()
@property (nonatomic, copy) NSString *space;
@property (nonatomic, assign) BOOL forSwift;
@property (nonatomic, assign) BOOL forSwiftEnum;
@end

@implementation VVBaseCommenter
-(instancetype) initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    self = [super init];
    if (self) {
        _indent = indent;
        _code = code;
        _arguments = [NSMutableArray array];
        _space = [[VVDocumenterSetting defaultSetting] spacesString];
        _forSwift = NO;
        _forSwiftEnum = NO;
    }
    return self;
}

-(NSString *) paramSymbol {
    return self.forSwift ? @"- parameter" : @"@param";
}

-(NSString *) returnSymbol {
    return self.forSwift ? @"- returns:" : @"@return";
}

-(NSString *) throwsSymbol {
    return @"- throws:";
}

-(NSString *) startCommentWithDescriptionTag:(NSString *)tag {
    NSString *authorInfo = @"";
    
    if ([[VVDocumenterSetting defaultSetting] useAuthorInformation] && !self.forSwift) {
        NSMutableString *authorCotent = @"".mutableCopy;
        
        if ([[VVDocumenterSetting defaultSetting] authorInformation].length > 0) {
            [authorCotent appendString:[[VVDocumenterSetting defaultSetting] authorInformation]];
        }
        
        if ([[VVDocumenterSetting defaultSetting] useDateInformation]) {
            NSString *formatString = [[VVDocumenterSetting defaultSetting] dateInformationFormat];
            if ([formatString length] <= 0) {
                formatString = @"MM-dd-YYYY HH:MM:ss";
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formatString];
            
            if (authorCotent.length > 0) {
                [authorCotent appendString:@", "];
            }
            [authorCotent appendString:[formatter stringFromDate:[NSDate date]]];
        }
        
        authorInfo = [NSString stringWithFormat:@"%@@author %@\n%@\n", self.prefixString, authorCotent, self.prefixString];
    }
    
    if ([[VVDocumenterSetting defaultSetting] useHeaderDoc]) {
        return [NSString stringWithFormat:@"%@/*!\n%@%@%@<#Description#>\n", self.indent, authorInfo, self.prefixString, tag];
    } else if ([[VVDocumenterSetting defaultSetting] prefixWithSlashes]) {
        return [NSString stringWithFormat:@"%@%@%@<#Description#>\n", self.prefixString, authorInfo, tag];
    } else {
        return [NSString stringWithFormat:@"%@/**\n%@%@%@<#Description#>\n", self.indent, authorInfo, self.prefixString, tag];
    }
}

-(NSString *) startComment
{
    NSString *descriptionTag =
    [[VVDocumenterSetting defaultSetting] briefDescription] && !self.forSwift ? @"@brief  " : @"";
    return [self startCommentWithDescriptionTag:descriptionTag];
}

-(NSString *) argumentsComment
{
    if (self.arguments.count == 0)
        return @"";

    // start off with an empty line
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@", self.emptyLine];

    int longestNameLength = [[self.arguments valueForKeyPath:@"@max.name.length"] intValue];
    BOOL useSpace = [[VVDocumenterSetting defaultSetting] useSpaces];
    
    for (VVArgument *arg in self.arguments) {
        NSString *name = arg.name;

        if ([[VVDocumenterSetting defaultSetting] alignArgumentComments]) {
            if (self.forSwiftEnum) {
                if (useSpace) {
                    name = [[name stringByAppendingString:@":"] stringByPaddingToLength:longestNameLength + 1 withString:@" " startingAtIndex:0];
                } else {
                    NSInteger tabSpaceRateCount = [[VVDocumenterSetting defaultSetting] spaceCount];
                    NSInteger neededTabCount = (longestNameLength + tabSpaceRateCount - name.length) / tabSpaceRateCount - 1;
                    name = [[name stringByAppendingString:@":"] stringByPaddingToLength:(name.length + 1 + neededTabCount) withString:@"\t" startingAtIndex:0];
                }
            } else {
                if (self.forSwift) {
                    name = [name stringByAppendingString:@":"];
                    if (useSpace) {
                        name = [name stringByPaddingToLength:longestNameLength + 1 withString:@" " startingAtIndex:0];
                    } else {
                        NSInteger tabSpaceRateCount = [[VVDocumenterSetting defaultSetting] spaceCount];
                        NSInteger neededTabCount = (longestNameLength + 1 + tabSpaceRateCount - name.length) / tabSpaceRateCount - 1;
                        name = [name stringByPaddingToLength:(name.length + neededTabCount) withString:@"\t" startingAtIndex:0];
                    }
                } else {
                    if (useSpace) {
                        name = [name stringByPaddingToLength:longestNameLength withString:@" " startingAtIndex:0];
                    } else {
                        NSInteger tabSpaceRateCount = [[VVDocumenterSetting defaultSetting] spaceCount];
                        NSInteger neededTabCount = (longestNameLength + tabSpaceRateCount - name.length) / tabSpaceRateCount - 1;
                        name = [name stringByPaddingToLength:(name.length + neededTabCount) withString:@"\t" startingAtIndex:0];
                    }
                }
            }
        }

        NSString *indentString = useSpace ? @" " : @"\t";
        if (self.forSwiftEnum) {
            [result appendFormat:@"%@- %@%@<#%@ description#>\n", self.prefixString, name, indentString, arg.name];
        } else {
            [result appendFormat:@"%@%@ %@%@<#%@ description#>\n", self.prefixString, [self paramSymbol], name, indentString, arg.name];
        }

    }
    return result;
}

-(NSString *) returnComment
{
    if (!self.hasReturn) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@%@%@ <#return value description#>\n", self.emptyLine, self.prefixString, [self returnSymbol]];
    }
}

-(NSString *) throwsComment
{
    if (!self.hasThrows) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@%@%@ <#throws value description#>\n", self.emptyLine, self.prefixString, [self throwsSymbol]];
    }
}

-(NSString *) sinceComment
{
    //It seems no since attribute for swift? Maybe I am wrong.
    VVProject *project = [VVProject projectForKeyWindow];
    
    if (!self.forSwift && [[VVDocumenterSetting defaultSetting] addSinceToComments]) {

        VVDSinceOption sinceOption = [[VVDocumenterSetting defaultSetting] sinceOption];

        switch (sinceOption) {
            case VVDSinceOptionPlaceholder: {

                return [NSString stringWithFormat:@"%@%@@since <#version number#>\n", self.emptyLine, self.prefixString];
                break;
            }
            case VVDSinceOptionProjectVersion: {

                if (project.projectVersion && project.projectVersion.length>0) {

                    return [NSString stringWithFormat:@"%@%@@since <#%@#>\n", self.emptyLine, self.prefixString,project.projectVersion];
                }else{
                    // Fall back onto default placeholder if no project version can be obtained.
                    return [NSString stringWithFormat:@"%@%@@since <#version number#>\n", self.emptyLine, self.prefixString];
                }

                break;
            }
            case VVDSinceOptionSpecificVersion: {

                NSString *version = [[VVDocumenterSetting defaultSetting] sinceVersion];
                if (version && version.length>0) {

                    return [NSString stringWithFormat:@"%@%@@since <#%@#>\n", self.emptyLine, self.prefixString, version];
                }else{
                    // Fall back onto default placeholder if no version can be obtained.
                    return [NSString stringWithFormat:@"%@%@@since <#version number#>\n", self.emptyLine, self.prefixString];
                }
                break;
            }
        }
    } else {
        return @"";
    }
}

-(NSString *) endComment
{
    if ([[VVDocumenterSetting defaultSetting] prefixWithSlashes]) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@ */",self.indent];
    }
}

-(NSString *) documentForSwift
{
    self.forSwift = YES;
    return [self __document];
}

-(NSString *) documentForSwiftEnum
{
    self.forSwiftEnum = YES;
    self.forSwift = YES;
    return [self __document];
}

-(NSString *) documentForC
{
    self.forSwift = NO;
    return [self __document];
}

-(NSString *) __document
{
    NSString * comment = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                          [self startComment],
                          [self argumentsComment],
                          [self throwsComment],
                          [self returnComment],
                          [self sinceComment],
                          [self endComment]];
    
    // The last line of the comment should be adjacent to the next line of code,
    // back off the newline from the last comment component.
    if ([[VVDocumenterSetting defaultSetting] prefixWithSlashes]) {
        return [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        return comment;
    }
}

-(NSString *) document
{
    //This is the default action
    return [self documentForC];
}

-(NSString *) emptyLine
{
    if ([[VVDocumenterSetting defaultSetting] blankLinesBetweenSections]) {
        return [[NSString stringWithFormat:@"%@\n", self.prefixString] vv_stringByTrimEndSpaces];
    } else {
        return @"";
    }
}

-(NSString *) prefixString
{
    if ([[VVDocumenterSetting defaultSetting] prefixWithStar] && !self.forSwift) {
        return [NSString stringWithFormat:@"%@ *%@", self.indent, self.space];
    } else if ([[VVDocumenterSetting defaultSetting] prefixWithSlashes]) {
        return [NSString stringWithFormat:@"%@///%@", self.indent, self.space];
    } else {
        return [NSString stringWithFormat:@"%@ ", self.indent];
    }
}

-(void) parseArgumentsInputArgs:(NSString *)rawArgsCode
{
    [self.arguments removeAllObjects];
    if (rawArgsCode.length == 0) {
        return;
    }

    NSArray *argumentStrings = [rawArgsCode componentsSeparatedByString:@","];
    for (__strong NSString *argumentString in argumentStrings) {
        VVArgument *arg = [[VVArgument alloc] init];
        argumentString = [argumentString vv_stringByReplacingRegexPattern:@"=\\s*\\w*" withString:@""];
        argumentString = [argumentString vv_stringByReplacingRegexPattern:@"\\(" withString:@" "];
        argumentString = [argumentString vv_stringByReplacingRegexPattern:@"\\*" withString:@" "];
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

-(BOOL) shouldComment
{
    return YES;
}

@end
