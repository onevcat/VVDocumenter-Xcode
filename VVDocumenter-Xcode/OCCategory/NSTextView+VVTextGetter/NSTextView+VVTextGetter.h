//
//  NSTextView+VVTextGetter.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VVTextResult : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, copy) NSString *string;
@end

@interface NSTextView (VVTextGetter)

-(VVTextResult *) textResultOfCurrentLine;

-(VVTextResult *) textResultUntilNextString:(NSString *)findString;

@end
