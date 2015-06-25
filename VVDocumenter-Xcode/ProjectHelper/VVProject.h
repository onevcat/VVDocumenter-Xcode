//
//  VVProject.h
//  VVDocumenter-Xcode
//
//  Created by 夏天味道 on 15/6/25.
//  Copyright (c) 2015年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVProject : NSObject

@property (nonatomic, strong) NSString *directoryPath;

@property (nonatomic, readonly) NSString *workspacePath;

@property (nonatomic, strong) NSString *projectName;

@property (nonatomic, strong) NSDictionary *infoDictionary;

@property (nonatomic, strong) NSString *projectVersion;

+ (instancetype)projectForKeyWindow;

@end
