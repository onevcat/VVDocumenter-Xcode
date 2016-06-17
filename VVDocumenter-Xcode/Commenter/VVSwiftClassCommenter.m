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

/**
 *  Capture class name from extracted regex groups
 *
 *  @param groups regex groups
 */
-(void) captureClassNameFrom:(NSArray *)groups
{
    self.className = [groups objectAtIndex:1];
    // if there are additional annotations like `public`, `private`, `final`
    if ([groups count] > 3) {
        self.className = [groups objectAtIndex:2];
    }
}

/**
 *  Capture inheritances from extracted regex groups
 *
 *  @param groups regex groups
 */
-(void) captureInheritancesFrom:(NSArray *)groups {
    self.inheritances = [[[groups lastObject] componentsSeparatedByString:@","] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        NSString *strippedString = [[NSString stringWithFormat:@"%@", evaluatedObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        return strippedString.length > 0;
    }]];
}

/**
 *  Append inheritance info string to comment string
 *
 *  @param string comment string want to append to
 */
-(void) appendInheritanceStringTo:(NSMutableString *)string {
    if ([self.inheritances count] > 0) {
        [string appendString:@"inherits from or conforms to:\n"];
        for (NSString *inheritance in self.inheritances) {
            [string appendFormat:@"%@: <#Description#>\n", [inheritance stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
    }
}

// override super document function to change default comment behavior
-(NSString *) document
{
    NSArray *groups = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"^\\s*((.*\\s)?class\\s+)([^:]+):?(.*)\\{"];
    
    [self captureClassNameFrom:groups];
    
    NSMutableString *commentString = [NSMutableString new];
    [commentString appendFormat:@"/**\n%@@class %@\n\n@abstract <#Description#>\n", self.indent, self.className];
    [commentString appendFormat:@"\n %@*/", self.indent];
    
    return commentString;
}

@end
