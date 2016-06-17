//
//  VVSwiftClassCommenter.m
//  VVDocumenter-Xcode
//
//  Created by Li Jiantang on 16/06/2016.
//  Copyright © 2016 OneV's Den. All rights reserved.
//

#import "VVSwiftClassCommenter.h"
#import "NSString+VVTextGetter.h"
#import "VVTextResult.h"
#import "VVArgument.h"

@interface VVSwiftClassCommenter()

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSArray *inheritances;

@end

@implementation VVSwiftClassCommenter

-(void) captureClassName
{
    NSArray *groups = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"^\\s*((.*\\s)?class\\s+)([^:]+):?(.*)\\{"];
    
    self.className = [groups objectAtIndex:1];
    if ([groups count] > 3) {
        self.className = [groups objectAtIndex:2];
    }
    
    self.inheritances = [[[groups lastObject] componentsSeparatedByString:@","] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedString, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        NSString *strippedString = [evaluatedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        return strippedString.length > 0;
    }]];
}

-(NSString *) document
{
    [self captureClassName];
    
    NSMutableString *finalString = [NSMutableString new];
    [finalString appendFormat:@"/**\n%@class %@\n\n<#Description#>\n\n", self.indent, self.className];
    
    if ([self.inheritances count] > 0) {
        [finalString appendString:@"inherit from or conform to:\n"];
        for (NSString *inheritance in self.inheritances) {
            [finalString appendFormat:@"%@: <#Description#>\n", [inheritance stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
    }
    
    [finalString appendFormat:@"\n %@*/", self.indent];
    
    return finalString;
}

@end
