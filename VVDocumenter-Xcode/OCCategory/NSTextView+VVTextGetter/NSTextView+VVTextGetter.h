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
-(NSInteger) currentCurseLocation;

-(VVTextResult *) textResultOfCurrentLine;

-(VVTextResult *) textResultOfPreviousLine;

-(VVTextResult *) textResultOfNextLine;

-(VVTextResult *) textResultUntilNextString:(NSString *)findString;

-(VVTextResult *) textResultWithPairOpenString:(NSString *)open closeString:(NSString *)close;

@end
