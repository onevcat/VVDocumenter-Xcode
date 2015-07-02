//
//  VVProject.m
//  VVDocumenter-Xcode
//
//  Created by 夏天味道 on 15/6/25.
//  Copyright (c) 2015年 OneV's Den. All rights reserved.
//

#import "VVProject.h"
#import "VVWorkspaceManager.h"

@implementation VVProject

+ (instancetype)projectForKeyWindow
{
    id workspace = [VVWorkspaceManager workspaceForKeyWindow];
    
    id contextManager = [workspace valueForKey:@"_runContextManager"];
    for (id scheme in[contextManager valueForKey:@"runContexts"]) {
        NSString *schemeName = [scheme valueForKey:@"name"];
        if (![schemeName hasPrefix:@"Pods-"]) {
            NSString *path = [VVWorkspaceManager directoryPathForWorkspace:workspace];
            return [[VVProject alloc] initWithName:schemeName path:path];
        }
    }
    
    return nil;
}

- (id)initWithName:(NSString *)name
              path:(NSString *)path
{
    if (self = [self init]) {
        _projectName = name;
        _directoryPath = path;
        
        //FIXME: 此处应从工程配置文件中,获取info.plist文件名称. 目前使用默认名称查找
        NSString *infoPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@-Info.plist", _projectName, _projectName]];
        
        _infoDictionary = [NSDictionary dictionaryWithContentsOfFile:infoPath];
        
        _projectVersion = self.infoDictionary[@"CFBundleShortVersionString"];
    }
    
    return self;
}

@end
