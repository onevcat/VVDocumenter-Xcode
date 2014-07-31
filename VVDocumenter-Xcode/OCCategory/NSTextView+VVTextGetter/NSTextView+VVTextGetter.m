//
//  NSTextView+VVTextGetter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "NSTextView+VVTextGetter.h"
#import "VVTextResult.h"
#import "NSString+VVTextGetter.h"

@implementation NSTextView (VVTextGetter)
-(NSInteger) currentCurseLocation
{
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

-(VVTextResult *) textResultOfCurrentLine
{
    return [self.textStorage.string textResultOfCurrentLineCurrentLocation:[self currentCurseLocation]];
}

-(VVTextResult *) textResultOfPreviousLine
{
    return [self.textStorage.string textResultOfPreviousLineCurrentLocation:[self currentCurseLocation]];
}

-(VVTextResult *) textResultOfNextLine
{
    return [self.textStorage.string textResultOfNextLineCurrentLocation:[self currentCurseLocation]];
}

-(VVTextResult *) textResultUntilNextString:(NSString *)findString
{
    return [self.textStorage.string textResultUntilNextString:findString currentLocation:[self currentCurseLocation]];
}


-(VVTextResult *) textResultWithPairOpenString:(NSString *)open closeString:(NSString *)close
{
    return [self.textStorage.string textResultWithPairOpenString:open closeString:close currentLocation:[self currentCurseLocation]];
}

@end
