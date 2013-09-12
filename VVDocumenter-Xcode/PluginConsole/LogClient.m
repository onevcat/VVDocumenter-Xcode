//
//  LogClient.m
//  PluginConsole
//
//  Created by Александр Северьянов on 16.05.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import "LogClient.h"
#import <AppKit/AppKit.h>

NSString * const PluginLoggerShouldLogNotification = @"PluginLoggerShouldLogNotification";

void PluginLogWithName(NSString *pluginName, NSString *format, ...)
{
    NSString *name = @"";
    if (pluginName.length) {
        name = pluginName;
    }
    va_list argumentList;
    va_start(argumentList, format);
    NSString *string = [NSString stringWithFormat:@"%@ Plugin Console %@: ", [NSDate date], name];
    NSString* msg = [[[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@%@",string, format] arguments:argumentList] autorelease];
    NSMutableAttributedString *logString = [[NSMutableAttributedString alloc] initWithString:msg attributes:nil];
    [logString setAttributes:[NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Helvetica-Bold" size:15.f] forKey:NSFontAttributeName] range:NSMakeRange(0, string.length)];
    [[NSNotificationCenter defaultCenter] postNotificationName:PluginLoggerShouldLogNotification object:logString];
    va_end(argumentList);
}

void PluginLog(NSString *format, ...)
{
    va_list argumentList;
    va_start(argumentList, format);
    NSString *string = [NSString stringWithFormat:@"%@ Plugin Console: ", [NSDate date]];
    NSString* msg = [[[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@%@",string, format] arguments:argumentList] autorelease];
    NSMutableAttributedString *logString = [[NSMutableAttributedString alloc] initWithString:msg attributes:nil];
    [logString setAttributes:[NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Helvetica-Bold" size:15.f] forKey:NSFontAttributeName] range:NSMakeRange(0, string.length)];
    [[NSNotificationCenter defaultCenter] postNotificationName:PluginLoggerShouldLogNotification object:logString];
    va_end(argumentList);
}
