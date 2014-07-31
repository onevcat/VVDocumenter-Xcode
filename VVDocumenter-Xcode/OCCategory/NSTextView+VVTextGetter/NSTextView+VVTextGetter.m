//
//  NSTextView+VVTextGetter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "NSTextView+VVTextGetter.h"

@implementation VVTextResult

-(id) initWithRange:(NSRange)aRange string:(NSString *)aString

{
    self = [super init];
    if (self) {
        _range = aRange;
        _string = aString;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Location:%ld, Length:%ld, String:%@",self.range.location,self.range.length,self.string];
}

@end

@implementation NSTextView (VVTextGetter)
-(NSInteger) currentCurseLocation
{
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

-(VVTextResult *) textResultOfCurrentLine
{
    NSString *string = self.textStorage.string;
    NSInteger curseLocation = [self currentCurseLocation];
    NSRange range = NSMakeRange(0, curseLocation);
    NSRange thisLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch range:range];

    NSString *line = nil;
    if (thisLineRange.location != NSNotFound) {
        NSRange lineRange = NSMakeRange(thisLineRange.location + 1, curseLocation - thisLineRange.location - 1);
        if (lineRange.location < [string length] && NSMaxRange(lineRange) < [string length]) {
            line = [string substringWithRange:lineRange];
            return [[VVTextResult alloc] initWithRange:lineRange string:line];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(VVTextResult *) textResultOfPreviousLine
{
    NSString *string = self.textStorage.string;
    NSInteger curseLocation = [self currentCurseLocation];
    NSRange range = NSMakeRange(0, curseLocation);
    NSRange thisLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch range:range];

    NSString *line = nil;
    if (thisLineRange.location != NSNotFound) {
        range = NSMakeRange(0, thisLineRange.location);
        NSRange previousLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch range:range];

        if (previousLineRange.location != NSNotFound) {
            NSRange lineRange = NSMakeRange(previousLineRange.location + 1, thisLineRange.location - previousLineRange.location);
            if (lineRange.location < [string length] && NSMaxRange(lineRange) < [string length]) {
                line = [string substringWithRange:lineRange];
                return [[VVTextResult alloc] initWithRange:lineRange string:line];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(VVTextResult *) textResultOfNextLine
{
    NSString *string = self.textStorage.string;
    NSInteger curseLocation = [self currentCurseLocation];
    NSRange range = NSMakeRange(curseLocation, string.length - curseLocation);
    NSRange thisLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:range];

    NSString *line = nil;
    if (thisLineRange.location != NSNotFound) {
        range = NSMakeRange(thisLineRange.location + 1, string.length - thisLineRange.location - 1);
        NSRange nextLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:range];

        if (nextLineRange.location != NSNotFound) {
            NSRange lineRange = NSMakeRange(thisLineRange.location + 1, NSMaxRange(nextLineRange) - NSMaxRange(thisLineRange));
            if (lineRange.location < [string length] && NSMaxRange(lineRange) < [string length]) {
                line = [string substringWithRange:lineRange];
                return [[VVTextResult alloc] initWithRange:lineRange string:line];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(VVTextResult *) textResultUntilNextString:(NSString *)findString
{
    NSString *string = self.textStorage.string;
    NSInteger curseLocation = [self currentCurseLocation];

    NSRange range = NSMakeRange(curseLocation, string.length - curseLocation);
    NSRange nextLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:range];
    NSRange rangeToString = [string rangeOfString:findString options:0 range:range];

    NSString *line = nil;
    if (nextLineRange.location != NSNotFound && rangeToString.location != NSNotFound && nextLineRange.location < rangeToString.location) {
        NSRange lineRange = NSMakeRange(nextLineRange.location + 1, rangeToString.location - nextLineRange.location);
        if (lineRange.location < [string length] && NSMaxRange(lineRange) < [string length]) {
            line = [string substringWithRange:lineRange];
            return [[VVTextResult alloc] initWithRange:lineRange string:line];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}


-(VVTextResult *) textResultWithPairOpenString:(NSString *)open closeString:(NSString *)close
{
    // Find all content from current positon to the last paired scope. Useful when pairing `{}` or `()`
    NSString *string = self.textStorage.string;
    NSInteger curseLocation = [self currentCurseLocation];
    
    NSRange range = NSMakeRange(curseLocation, string.length - curseLocation);
    
    // searchRange will be updated to new range later, for search the next open/close token.
    NSRange searchRange = range;
    VVLog(@"Begin Search Range: %lu, %lu", (unsigned long)searchRange.location, (unsigned long)searchRange.length);
    
    NSInteger openCount = 0;
    NSInteger closeCount = 0;
    
    NSRange nextOpenRange = [string rangeOfString:open options:0 range:searchRange];
    NSRange nextCloseRange = [string rangeOfString:close options:0 range:searchRange];
    
    // Not even open. Early return
    if (nextOpenRange.location == NSNotFound || nextCloseRange.location == NSNotFound || nextCloseRange.location < nextOpenRange.location) {
        return nil;
    }
    
    openCount++;
    
    // Update the search range: from current token to the end.
    searchRange = NSMakeRange(nextOpenRange.location + 1, string.length - nextOpenRange.location - 1);
    VVLog(@"Update Search Range: %lu, %lu", (unsigned long)searchRange.location, (unsigned long)searchRange.length);
    
    // Try to find the scope by pairing open and close count
    NSRange targetRange = NSMakeRange(0,0);
    while (openCount != closeCount) {
        // Get next open and close token location
        nextOpenRange = [string rangeOfString:open options:0 range:searchRange];
        nextCloseRange = [string rangeOfString:close options:0 range:searchRange];

        // No new close token. This scope will not close.
        if (nextCloseRange.location == NSNotFound) {
            return nil;
        }
        
        if (nextOpenRange.location < nextCloseRange.location) {
            targetRange = nextOpenRange;
            openCount++;
        } else {
            targetRange = nextCloseRange;
            closeCount++;
        }
        
        VVLog(@"Open:%ld, Close:%ld",(long)openCount,(long)closeCount);
        // Update the search range: from current token to the end.
        searchRange = NSMakeRange(targetRange.location + 1, string.length - targetRange.location - 1);
        VVLog(@"Target Range: %lu, %lu",targetRange.location,targetRange.length);
        VVLog(@"Update Search Range: %lu, %lu", (unsigned long)searchRange.location, (unsigned long)searchRange.length);
    }
    
    // Extract the code need to be documented. From next line to the matched scope end.
    NSRange nextLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:range];
    NSRange resultRange = NSMakeRange(nextLineRange.location + 1, targetRange.location - nextLineRange.location);
    
    if (resultRange.location < [string length] && NSMaxRange(resultRange) < [string length]) {
        NSString *result = [string substringWithRange:resultRange];
        return [[VVTextResult alloc] initWithRange:resultRange string:result];
    } else {
        return nil;
    }
}

@end
