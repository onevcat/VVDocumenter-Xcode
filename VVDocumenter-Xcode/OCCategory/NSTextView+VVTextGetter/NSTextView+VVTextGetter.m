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
        self.range = aRange;
        self.string = aString;
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

@end
