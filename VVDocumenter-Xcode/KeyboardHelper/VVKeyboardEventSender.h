//
//  VVKeyboardEventSender.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-26.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


@interface VVKeyboardEventSender : NSObject
-(void) beginKeyBoradEvents;
-(void) sendKeyCode:(NSInteger)keyCode;
-(void) sendKeyCode:(NSInteger)keyCode withModifierCommand:(BOOL)command
                                                       alt:(BOOL)alt
                                                     shift:(BOOL)shift
                                                   control:(BOOL)control;
-(void) sendKeyCode:(NSInteger)keyCode withModifier:(NSInteger)modifierMask;
-(void) endKeyBoradEvents;
@end
