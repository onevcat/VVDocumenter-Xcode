//
//  VVKeyboardEventSender.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-26.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVKeyboardEventSender.h"

@interface VVKeyboardEventSender()
{
    CGEventSourceRef _source;
    CGEventTapLocation _location;
}
@end

@implementation VVKeyboardEventSender
-(void) beginKeyBoradEvents
{
    _source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    _location = kCGHIDEventTap;
}

-(void) sendKeyCode:(NSInteger)keyCode
{
    [self sendKeyCode:keyCode withModifier:0];
}

-(void) sendKeyCode:(NSInteger)keyCode withModifierCommand:(BOOL)command
                alt:(BOOL)alt
              shift:(BOOL)shift
            control:(BOOL)control
{
    NSInteger modifier = 0;
    if (command) {
        modifier = modifier ^ kCGEventFlagMaskCommand;
    }
    if (alt) {
        modifier = modifier ^ kCGEventFlagMaskAlternate;
    }
    if (shift) {
        modifier = modifier ^ kCGEventFlagMaskShift;
    }
    if (control) {
        modifier = modifier ^ kCGEventFlagMaskControl;
    }

    [self sendKeyCode:keyCode withModifier:modifier];
}

-(void) sendKeyCode:(NSInteger)keyCode withModifier:(NSInteger)modifierMask
{
    NSAssert(_source != NULL, @"You should call -beginKeyBoradEvents before sending a key event");
    CGEventRef event;
    event = CGEventCreateKeyboardEvent(_source, keyCode, true);
    CGEventSetFlags(event, modifierMask);
    CGEventPost(_location, event);
    CFRelease(event);
    
    event = CGEventCreateKeyboardEvent(_source, keyCode, false);
    CGEventSetFlags(event, modifierMask);
    CGEventPost(_location, event);
    CFRelease(event);
}

-(void) endKeyBoradEvents
{
    NSAssert(_source != NULL, @"You should call -beginKeyBoradEvents before end current keyborad event");
    CFRelease(_source);
    _source = nil;
}
@end
