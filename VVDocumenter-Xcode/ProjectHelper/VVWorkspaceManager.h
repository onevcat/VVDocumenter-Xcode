//
//  VVWorkspaceManager.h
//  VVDocumenter-Xcode
//
//  Created by 夏天味道 on 15/6/25.
//  Copyright (c) 2015年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVWorkspaceManager : NSObject

+ (id)workspaceForKeyWindow;

+ (NSString *)currentWorkspaceDirectoryPath;
+ (NSString *)directoryPathForWorkspace:(id)workspace;

@end
