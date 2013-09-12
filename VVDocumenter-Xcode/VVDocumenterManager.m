//
//  VVDocumenterManager.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-16.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVDocumenterManager.h"
#import "NSTextView+VVTextGetter.h"
#import "NSString+VVSyntax.h"
#import "VVDocumenter.h"
#import "VVKeyboardEventSender.h"
#import "VVDSettingPanelWindowController.h"
#import "VVDocumenterSetting.h"

@interface VVDocumenterManager()
@property (nonatomic, retain) id eventMonitor;
@property (nonatomic, assign) BOOL prefixTyped;
@end

@implementation VVDocumenterManager
+(void)pluginDidLoad:(NSBundle *)plugin {
    VVLog(@"VVDocumenter: Plugin loaded successfully");
    [self shared];
}

+(id) shared {
    static dispatch_once_t once;
    static id instance = nil;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void) applicationDidFinishLaunching: (NSNotification*) noti {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textStorageDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];
    [self addSettingMenu];
}

-(void) addSettingMenu
{
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (editMenuItem) {
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"VVDocumenter" action:@selector(showSettingPanel:) keyEquivalent:@""];
        
        [newMenuItem setTarget:self];
        [[editMenuItem submenu] addItem:newMenuItem];
        [newMenuItem release];
    }
}

-(void) showSettingPanel:(NSNotification *)noti {
    VVDSettingPanelWindowController *panelController = [[VVDSettingPanelWindowController alloc] initWithWindowNibName:@"VVDSettingPanelWindowController"];
    [panelController showWindow:panelController];
}

- (void) textStorageDidChange:(NSNotification *)noti {

    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)[noti object];
        VVTextResult *currentLineResult = [textView textResultOfCurrentLine];
        if (currentLineResult) {

            //Check if there is a "//" already typed in. We do this to solve the undo issue
            //Otherwise when you press Cmd+Z, "///" will be recognized and trigger the doc inserting, so you can not perform an undo.
            NSString *triggerString = [[VVDocumenterSetting defaultSetting] triggerString];
            
            if (triggerString.length > 1) {
                NSString *preTypeString = [triggerString substringToIndex:triggerString.length - 2];
                self.prefixTyped = [currentLineResult.string vv_matchesPatternRegexPattern:[NSString stringWithFormat:@"^\\s*%@$",[NSRegularExpression escapedPatternForString:preTypeString]]] | self.prefixTyped;
            } else {
                self.prefixTyped = YES;
            }
            
            if ([currentLineResult.string vv_matchesPatternRegexPattern:[NSString stringWithFormat:@"^\\s*%@$",[NSRegularExpression escapedPatternForString:triggerString]]] && self.prefixTyped) {
                self.prefixTyped = NO;
                //Get a @"///" typed in by user. Do work!
                BOOL shouldReplace = NO;
                //Decide which is closer to the cursor. A semicolon or a half brace.
                //We just want to document the next valid line.
                VVTextResult *resultUntilSemiColon = [textView textResultUntilNextString:@";"];
                VVTextResult *resultUntilBrace = [textView textResultUntilNextString:@"{"];
                
                VVTextResult *resultToDocument = nil;
                
                if (resultUntilSemiColon && resultUntilBrace) {
                    resultToDocument = (resultUntilSemiColon.range.length < resultUntilBrace.range.length) ? resultUntilSemiColon : resultUntilBrace;
                } else if (resultUntilBrace) {
                    resultToDocument = resultUntilBrace;
                } else {
                    resultToDocument = resultUntilSemiColon;
                }
                
                if ([resultToDocument.string vv_isEnum]) {
                    resultToDocument = resultUntilSemiColon;
                    shouldReplace = YES;
                }
                
                VVDocumenter *doc = [[VVDocumenter alloc] initWithCode:resultToDocument.string];

                //Now we are using a simulation of keyboard event to insert the docs, instead of using the IDE's private method.
                //See more at https://github.com/onevcat/VVDocumenter-Xcode/issues/3

                //Save current content in paste board
                NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
                NSString *originPBString = [pasteBoard stringForType:NSPasteboardTypeString];

                //Set the doc comments in it
                [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
                [pasteBoard setString:[doc document] forType:NSStringPboardType];

                //Begin to simulate keyborad pressing
                VVKeyboardEventSender *kes = [[VVKeyboardEventSender alloc] init];
                [kes beginKeyBoradEvents];
                //Cmd+delete Delete current line
                [kes sendKeyCode:kVK_Delete withModifierCommand:YES alt:NO shift:NO control:NO];
                if (shouldReplace) [textView setSelectedRange:resultToDocument.range];
                //Cmd+V, paste
                [kes sendKeyCode:kVK_ANSI_V withModifierCommand:YES alt:NO shift:NO control:NO];
                //The key down is just a defined finish signal by me. When we receive this key, we know operation above is finished.
                [kes sendKeyCode:kVK_F20];

                self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent *incomingEvent) {
                    if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kVK_F20) {
                        //Finish signal arrived, no need to observe the event
                        [NSEvent removeMonitor:self.eventMonitor];
                        self.eventMonitor = nil;
                        
                        //Restore previois patse board content
                        [pasteBoard setString:originPBString forType:NSStringPboardType];
                        
                        //Set cursor before the inserted documentation. So we can use tab to begin edit.
                        int baseIndentationLength = (int)[doc baseIndentation].length;
                        [textView setSelectedRange:NSMakeRange(currentLineResult.range.location + baseIndentationLength, 0)];
                        
                        //Send a 'tab' after insert the doc. For our lazy programmers. :)
                        [kes sendKeyCode:kVK_Tab];
                        [kes endKeyBoradEvents];
                        
                        //Invalidate the finish signal, in case you set it to do some other thing.
                        return nil;
                    } else {
                        return incomingEvent;
                    }
                }];
            }
        }
    }
}

@end
