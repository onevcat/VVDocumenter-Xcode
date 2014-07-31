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
-(NSInteger) vv_currentCurseLocation
{
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

-(VVTextResult *) vv_textResultOfCurrentLine
{
    return [self.textStorage.string vv_textResultOfCurrentLineCurrentLocation:[self vv_currentCurseLocation]];
}

-(VVTextResult *) vv_textResultOfPreviousLine
{
    return [self.textStorage.string vv_textResultOfPreviousLineCurrentLocation:[self vv_currentCurseLocation]];
}

-(VVTextResult *) vv_textResultOfNextLine
{
    return [self.textStorage.string vv_textResultOfNextLineCurrentLocation:[self vv_currentCurseLocation]];
}

-(VVTextResult *) vv_textResultUntilNextString:(NSString *)findString
{
    return [self.textStorage.string vv_textResultUntilNextString:findString currentLocation:[self vv_currentCurseLocation]];
}


-(VVTextResult *) vv_textResultWithPairOpenString:(NSString *)open closeString:(NSString *)close
{
    return [self.textStorage.string vv_textResultWithPairOpenString:open closeString:close currentLocation:[self vv_currentCurseLocation]];
}

@end
