//
//  NSTextView+VVTextGetter.m
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

-(VVTextResult *) vv_textResultToEndOfFile
{
    return [self.textStorage.string vv_textResultToEndOfFileCurrentLocation:[self vv_currentCurseLocation]];
}

@end
