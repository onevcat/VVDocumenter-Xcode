//
//  XcodePrivate.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-20.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#ifndef VVDocumenter_Xcode_XcodePrivate_h
#define VVDocumenter_Xcode_XcodePrivate_h

#import <Cocoa/Cocoa.h>

@interface DVTSourceTextStorage : NSTextStorage
{
}

- (void)replaceCharactersInRange:(struct _NSRange)arg1 withString:(id)arg2 withUndoManager:(id)arg3;
@end
#endif
