//
//  VVProject.h
//  VVDocumenter-Xcode
//
//  Created by 夏天味道 on 15/6/25.
//  Copyright (c) 2015年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVProject : NSObject

@property (nonatomic, copy) NSString     *directoryPath;

@property (nonatomic,copy,readonly) NSString     *workspacePath;

@property (nonatomic, copy) NSString     *projectName;

@property (nonatomic, copy) NSDictionary *infoDictionary;

@property (nonatomic, copy) NSString     *projectVersion;

@property (nonatomic,copy) NSDictionary *pbxprojDictionary;

@property (nonatomic,copy) NSString     *organizeationName;


+ (instancetype)projectForKeyWindow;

@end
