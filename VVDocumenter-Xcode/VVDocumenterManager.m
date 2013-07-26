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
        NSTextView *textView = (NSTextView *)[noti object];
        VVTextResult *currentLineResult = [textView textResultOfCurrentLine];
        if (currentLineResult) {
            if ([currentLineResult.string vv_matchesPatternRegexPattern:@"^\\s*///"]) {
                //Get a @"///". Do work!
                
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
                
                VVDocumenter *doc = [[VVDocumenter alloc] initWithCode:resultToDocument.string];

                DVTSourceTextStorage *sts = (DVTSourceTextStorage *)textView.textStorage;
                [sts replaceCharactersInRange:currentLineResult.range withString:[doc document] withUndoManager:[textView undoManager]];
                
                //Set cursor before the inserted documentation. So we can use tab to begin edit.
                int baseIndentationLength = (int)[doc baseIndentation].length;
                [textView setSelectedRange:NSMakeRange(currentLineResult.range.location + baseIndentationLength, 0)];
                
                //Send a 'tab' after insert the doc. For our lazy programmers. :)
                [self sendTabEvent];
            }
        }
    }
}

-(void) sendTabEvent
{
    CGEventSourceRef src = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    //kVK_Tab = 0x30, See http://forums.macrumors.com/archive/index.php/t-1216916.html
    CGEventRef tab = CGEventCreateKeyboardEvent(src, 0x30, true);
    CGEventTapLocation loc = kCGHIDEventTap;
    CGEventPost(loc, tab);
    CFRelease(tab);
}

@end
