//
//  VVDocumenterSetting.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-8-3.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const VVDDefaultTriggerString;

@interface VVDocumenterSetting : NSObject
+ (VVDocumenterSetting *)defaultSetting;

@property (readonly) BOOL useDvorakLayout;
@property BOOL useSpaces;
@property NSInteger spaceCount;
@property NSString *triggerString;
@property BOOL prefixWithStar;
@property BOOL prefixWithSlashes;
@property BOOL addSinceToComments;
@property BOOL useHeaderDoc;
@property BOOL blankLinesBetweenSections;
@property BOOL alignArgumentComments;
@property (readonly) NSString *spacesString;
@end
