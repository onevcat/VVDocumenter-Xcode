//
//  NSTextView+VVTextGetter.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VVTextResult;

@interface NSTextView (VVTextGetter)
-(NSInteger) vv_currentCurseLocation;

-(VVTextResult *) vv_textResultOfCurrentLine;

-(VVTextResult *) vv_textResultOfPreviousLine;

-(VVTextResult *) vv_textResultOfNextLine;

-(VVTextResult *) vv_textResultUntilNextString:(NSString *)findString;

-(VVTextResult *) vv_textResultWithPairOpenString:(NSString *)open closeString:(NSString *)close;

@end
