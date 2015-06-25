//
//  VVWorkspaceManager.m
//  VVDocumenter-Xcode
//
//  Created by 夏天味道 on 15/6/25.
//  Copyright (c) 2015年 OneV's Den. All rights reserved.
//

#import "VVWorkspaceManager.h"

@implementation VVWorkspaceManager

+ (NSString *)currentWorkspaceDirectoryPath
{
    return [self directoryPathForWorkspace:[self workspaceForKeyWindow]];
}

+ (NSString *)directoryPathForWorkspace:(id)workspace
{
    NSString *workspacePath = [[workspace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    return [workspacePath stringByDeletingLastPathComponent];
}

#pragma mark - Private

+ (id)workspaceForKeyWindow
{
    return [self workspaceForWindow:[NSApp keyWindow]];
}

+ (id)workspaceForWindow:(NSWindow *)window
{
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    
    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isEqual:window]) {
            return [controller valueForKey:@"_workspace"];
        }
    }
    return nil;
}

@end
