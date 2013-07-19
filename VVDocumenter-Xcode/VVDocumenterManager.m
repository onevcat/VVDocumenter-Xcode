//
//  VVDocumenterManager.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-16.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVDocumenterManager.h"
#import "NSTextView+VVTextGetter.h"
#import "VVDocumenter.h"
#import "NSString+PDRegex.h"

@implementation VVDocumenterManager
+(void)pluginDidLoad:(NSBundle *)plugin {
    NSLog(@"VVDocumenter: Plugin loaded successfully");
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
                                             selector:@selector(textStorageBeginProcessEditing:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];

}

- (void) textStorageBeginProcessEditing:(NSNotification *)noti {
    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)[noti object];

        VVTextResult *currentLineResult = [textView textResultOfCurrentLine];
        if (currentLineResult) {
            if ([currentLineResult.string matchesPatternRegexPattern:@"^\\s*///"]) {

                VVTextResult *resultUntilSemiColon = [textView textResultUntilNextString:@";"];
                VVTextResult *resultUntilBrace = [textView textResultUntilNextString:@"{"];
                
                VVTextResult *resultToDocument = nil;
                
                if (resultUntilSemiColon && resultUntilBrace) {
                    resultToDocument = (resultUntilSemiColon.range.length < resultUntilBrace.range.length) ?
                                        resultUntilSemiColon : resultUntilBrace;
                } else if (resultUntilBrace) {
                    resultToDocument = resultUntilBrace;
                } else {
                    resultToDocument = resultUntilSemiColon;
                }
            
                VVDocumenter *doc = [[VVDocumenter alloc] initWithCode:resultToDocument.string];
                NSLog(@"%@",[doc document]);
            }
        }
///
//        NSString *string = textView.textStorage.string;
//        NSInteger insertionPoint = [[[textView selectedRanges] objectAtIndex:0] rangeValue].location;
//        NSRange range = NSMakeRange(0, insertionPoint);
//        NSRange thisLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch range:range];
//        NSString *line = string;
//        
//        if (thisLineRange.location != NSNotFound) {
//            NSRange lineRange = NSMakeRange(thisLineRange.location, insertionPoint - thisLineRange.location);
//            if (lineRange.location < [string length] && NSMaxRange(lineRange) < [string length]) {
//                line = [string substringWithRange:lineRange];
//            }
//            if ([line hasSuffix:@"///"]) {
//                
//            }
//        } else {
//
//        }
//
//        NSRange range1 = NSMakeRange(insertionPoint, string.length - insertionPoint);
//        NSLog(@"%ld,%ld",range1.location,range1.length);
//        NSRange nextLineRange = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:range1];
//        NSRange rangeToSemicolon = [string rangeOfString:@";" options:0 range:range1];
//        
//        NSLog(@"%ld,%ld",nextLineRange.location,nextLineRange.length);
//        if (nextLineRange.location != NSNotFound && rangeToSemicolon.location != NSNotFound && nextLineRange.location < rangeToSemicolon.location) {
//            NSRange lineRange = NSMakeRange(nextLineRange.location, rangeToSemicolon.location - nextLineRange.location);
//            if (lineRange.location < [string length] && NSMaxRange(lineRange) < [string length]) {
//                NSLog(@"miao");
//                line = [string substringWithRange:lineRange];
//            }
//            NSLog(@"2.%@",line);
//        }
//        
    }

}


@end
