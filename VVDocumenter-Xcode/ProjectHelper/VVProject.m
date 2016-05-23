//
//  VVProject.m
//  VVDocumenter-Xcode
//
//  Created by 夏天味道 on 15/6/25.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
        
        
        NSString *pbxprojPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcodeproj/project.pbxproj",name]];
        _pbxprojDictionary = [NSDictionary dictionaryWithContentsOfFile:pbxprojPath];
        
        
        
        _organizeationName = [self getOrganizeationName];
        NSString *infoplistName = [self infoplistNameWithAtScheme:name];
        
        NSString *infoPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", infoplistName]];
        
        
        _infoDictionary = [NSDictionary dictionaryWithContentsOfFile:infoPath];
        
        _projectVersion = self.infoDictionary[@"CFBundleShortVersionString"];
    }
    
    return self;
}

-(NSString *)getOrganizeationName{
    NSDictionary *objects = [_pbxprojDictionary objectForKey:@"objects"];
    NSString *rootObjectId = [_pbxprojDictionary objectForKey:@"rootObject"];
    
    NSDictionary *pbxProjectDic = [objects objectForKey:rootObjectId];
    NSDictionary *attributes = [pbxProjectDic objectForKey:@"attributes"];
    NSString *organizeationName = [attributes objectForKey:@"ORGANIZATIONNAME"];
    return organizeationName;
}

-(NSString *)infoplistNameWithAtScheme:(NSString *)currentSchemeName{
    NSDictionary *objects = [_pbxprojDictionary objectForKey:@"objects"];
    NSString *rootObjectId = [_pbxprojDictionary objectForKey:@"rootObject"];
    
    NSDictionary *pbxProjectDic = [objects objectForKey:rootObjectId];
    NSArray *targetIds = [pbxProjectDic objectForKey:@"targets"];
    NSString *currentTargetId;
    for (NSString *targetId in targetIds) {
        NSDictionary *targetDic = [objects objectForKey:targetId];
        NSString *targetName = [targetDic objectForKey:@"name"];
        if ([targetName isEqualToString:currentSchemeName]) {
            currentTargetId = targetId;
            break;
        }
    }
    if (!currentTargetId) {
        currentTargetId = [targetIds firstObject];
    }
    
    NSDictionary *targetDic = [objects objectForKey:currentTargetId];
    NSString *buildConfigurationListId = [targetDic objectForKey:@"buildConfigurationList"];
    
    NSDictionary *buildConfigurationListDic = [objects objectForKey:buildConfigurationListId];
    NSArray *buildConfigurationIds = [buildConfigurationListDic objectForKey:@"buildConfigurations"];
    
    NSString *debugBuildConfigurationId;
    for (NSString *buildConfigurationId in buildConfigurationIds) {
        NSDictionary *buildConfigurationDic = [objects objectForKey:buildConfigurationId];
        NSString *name = [buildConfigurationDic objectForKey:@"name"];
        if ([name isEqualToString:@"Debug"]) {
            debugBuildConfigurationId = buildConfigurationId;
            break;
        }
    }
    if (!debugBuildConfigurationId) {
        debugBuildConfigurationId = [buildConfigurationIds firstObject];
    }
    
    NSDictionary *buildConfigurationDic = [objects objectForKey:debugBuildConfigurationId];
    NSDictionary *buildSettings = [buildConfigurationDic objectForKey:@"buildSettings"];
    NSString *infoplistName = [buildSettings objectForKey:@"INFOPLIST_FILE"];
    return infoplistName;
}

@end
