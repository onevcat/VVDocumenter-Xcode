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
#import "XcodePrivate.h"
#import "VVKeyboardEventSender.h"

@interface VVDocumenterManager()
@property (nonatomic, retain) VVTextResult *currentLineResult;
@property (nonatomic, copy) NSString *originPBString;
@property (nonatomic, retain) VVDocumenter *doc;
@property (nonatomic, retain) NSTextView *textView;

@property (nonatomic, retain) id eventMonitor;
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

}

- (void) textStorageDidChange:(NSNotification *)noti {

    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        self.textView = (NSTextView *)[noti object];
        self.currentLineResult = [self.textView textResultOfCurrentLine];
        if (self.currentLineResult) {
            if ([self.currentLineResult.string vv_matchesPatternRegexPattern:@"^\\s*///"]) {
                //Get a @"///". Do work!
                
                //Decide which is closer to the cursor. A semicolon or a half brace.
                //We just want to document the next valid line.
                VVTextResult *resultUntilSemiColon = [self.textView textResultUntilNextString:@";"];
                VVTextResult *resultUntilBrace = [self.textView textResultUntilNextString:@"{"];

                VVTextResult *resultToDocument = nil;
                
                if (resultUntilSemiColon && resultUntilBrace) {
                    resultToDocument = (resultUntilSemiColon.range.length < resultUntilBrace.range.length) ? resultUntilSemiColon : resultUntilBrace;
                } else if (resultUntilBrace) {
                    resultToDocument = resultUntilBrace;
                } else {
                    resultToDocument = resultUntilSemiColon;
                }
                
                self.doc = [[VVDocumenter alloc] initWithCode:resultToDocument.string];

                NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
                self.originPBString = [pasteBoard stringForType:NSPasteboardTypeString];

                [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
                [pasteBoard setString:[self.doc document] forType:NSStringPboardType];

                VVKeyboardEventSender *kes = [[VVKeyboardEventSender alloc] init];
                [kes beginKeyBoradEvents];
                [kes sendKeyCode:kVK_LeftArrow withModifierCommand:YES alt:NO shift:YES control:NO];
                [kes sendKeyCode:kVK_Delete];
                [kes sendKeyCode:kVK_ANSI_V withModifierCommand:YES alt:NO shift:NO control:NO];
                [kes sendKeyCode:kVK_F20];

                self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent *incomingEvent) {
                    NSEvent *result = incomingEvent;
                    if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kVK_F20) {
                        
                        [NSEvent removeMonitor:self.eventMonitor];
                        self.eventMonitor = nil;
                        
                        [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
                        [pasteBoard setString:self.originPBString forType:NSStringPboardType];
                        
                        //Set cursor before the inserted documentation. So we can use tab to begin edit.
                        int baseIndentationLength = (int)[self.doc baseIndentation].length;
                        [self.textView setSelectedRange:NSMakeRange(self.currentLineResult.range.location + baseIndentationLength, 0)];
                        
                        //Send a 'tab' after insert the doc. For our lazy programmers. :)
                        [kes sendKeyCode:kVK_Tab];
                        [kes endKeyBoradEvents];
                    
                        return result;
                    } else {
                        return result;
                    }
                }];
            }
        }
    }
}

@end
