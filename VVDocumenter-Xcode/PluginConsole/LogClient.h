//
//  LogClient.h
//  PluginConsole
//
//  Created by Александр Северьянов on 16.05.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PluginLoggerShouldLogNotification;

FOUNDATION_EXPORT void PluginLogWithName(NSString *pluginName, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
FOUNDATION_EXPORT void PluginLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

