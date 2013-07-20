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
                                             selector:@selector(textStorageDidChanged:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];

}

- (void) textStorageDidChanged:(NSNotification *)noti {
    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)[noti object];

        VVTextResult *currentLineResult = [textView textResultOfCurrentLine];
        if (currentLineResult) {
            if ([currentLineResult.string matchesPatternRegexPattern:@"^\\s*///"]) {

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
                
                VVLog(@"VVDocumenter: Target string: %@",resultToDocument.string);
                VVDocumenter *doc = [[VVDocumenter alloc] initWithCode:resultToDocument.string];
                VVLog(@"%@",[doc document]);
            }
        }     
    }
}


@end
