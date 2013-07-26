//
//  NSString+PDRegex.m
//  RegexOnNSString
//
//  Created by Carl Brown on 10/3/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import "NSString+PDRegex.h"

@implementation NSString (PDRegex)

-(NSString *) vv_stringByReplacingRegexPattern:(NSString *)regex withString:(NSString *) replacement caseInsensitive:(BOOL)ignoreCase {
    return [self vv_stringByReplacingRegexPattern:regex withString:replacement caseInsensitive:ignoreCase treatAsOneLine:NO];
}

-(NSString *) vv_stringByReplacingRegexPattern:(NSString *)regex withString:(NSString *) replacement caseInsensitive:(BOOL) ignoreCase treatAsOneLine:(BOOL) assumeMultiLine {
    
    NSUInteger options=0;
    if (ignoreCase) {
        options = options | NSRegularExpressionCaseInsensitive;
    }
    if (assumeMultiLine) {
        options = options | NSRegularExpressionDotMatchesLineSeparators;
    }

    NSError *error=nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:&error];
    if (error) {
        NSLog(@"Error creating Regex: %@",[error description]);
        return nil;
    }
    
    NSString *retVal= [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
    return retVal;
}

-(NSString *) vv_stringByReplacingRegexPattern:(NSString *)regex withString:(NSString *) replacement {
    return [self vv_stringByReplacingRegexPattern:regex withString:replacement caseInsensitive:NO treatAsOneLine:NO];
}

-(NSArray *) vv_stringsByExtractingGroupsUsingRegexPattern:(NSString *)regex caseInsensitive:(BOOL) ignoreCase treatAsOneLine:(BOOL) assumeMultiLine {
    NSUInteger options=0;
    if (ignoreCase) {
        options = options | NSRegularExpressionCaseInsensitive;
    }
    if (assumeMultiLine) {
        options = options | NSRegularExpressionDotMatchesLineSeparators;
    }
    
    NSError *error=nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:&error];
    if (error) {
        NSLog(@"Error creating Regex: %@",[error description]);
        return nil;
    }

    __block NSMutableArray *retVal = [NSMutableArray array];
    [pattern enumerateMatchesInString:self options:0 range:NSMakeRange(0, [self length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        //Note, we only want to return the things in parens, so we're skipping index 0 intentionally
        for (int i=1; i<[result numberOfRanges]; i++) {
            NSString *matchedString=[self substringWithRange:[result rangeAtIndex:i]];
            [retVal addObject:matchedString];
        }
    }];
    return retVal;
}

-(NSArray *) vv_stringsByExtractingGroupsUsingRegexPattern:(NSString *)regex {
    return [self vv_stringsByExtractingGroupsUsingRegexPattern:regex caseInsensitive:NO treatAsOneLine:NO];
}

-(BOOL) vv_matchesPatternRegexPattern:(NSString *)regex caseInsensitive:(BOOL) ignoreCase treatAsOneLine:(BOOL) assumeMultiLine {
    NSUInteger options=0;
    if (ignoreCase) {
        options = options | NSRegularExpressionCaseInsensitive;
    }
    if (assumeMultiLine) {
        options = options | NSRegularExpressionDotMatchesLineSeparators;
    }
    
    NSError *error=nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:&error];
    if (error) {
        NSLog(@"Error creating Regex: %@",[error description]);
        return NO;  //Can't possibly match an invalid Regex
    }

    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])] > 0);
}

-(BOOL) vv_matchesPatternRegexPattern:(NSString *)regex {
    return [self vv_matchesPatternRegexPattern:regex caseInsensitive:NO treatAsOneLine:NO];
}

@end
