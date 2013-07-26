//
//  NSString+PDRegex.h
//  RegexOnNSString
//
//  Created by Carl Brown on 10/3/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import <Foundation/Foundation.h>

@interface NSString (PDRegex)

-(NSString *) vv_stringByReplacingRegexPattern:(NSString *)regex withString:(NSString *) replacement;
-(NSString *) vv_stringByReplacingRegexPattern:(NSString *)regex withString:(NSString *) replacement caseInsensitive:(BOOL) ignoreCase;
-(NSString *) vv_stringByReplacingRegexPattern:(NSString *)regex withString:(NSString *) replacement caseInsensitive:(BOOL) ignoreCase treatAsOneLine:(BOOL) assumeMultiLine;
-(NSArray *) vv_stringsByExtractingGroupsUsingRegexPattern:(NSString *)regex;
-(NSArray *) vv_stringsByExtractingGroupsUsingRegexPattern:(NSString *)regex caseInsensitive:(BOOL) ignoreCase treatAsOneLine:(BOOL) assumeMultiLine;
-(BOOL) vv_matchesPatternRegexPattern:(NSString *)regex;
-(BOOL) vv_matchesPatternRegexPattern:(NSString *)regex caseInsensitive:(BOOL) ignoreCase treatAsOneLine:(BOOL) assumeMultiLine;

@end
