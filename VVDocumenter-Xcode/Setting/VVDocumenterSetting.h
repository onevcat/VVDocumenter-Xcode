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

-(BOOL) useSpaces;
-(void) setUseSpaces:(BOOL)useSpace;

-(NSInteger) spaceCount;
-(void) setSpaceCount:(NSInteger)spaceCount;

-(NSString *) triggerString;
-(void) setTriggerString:(NSString *)triggerString;

-(BOOL) prefixWithStar;
-(void) setPrefixWithStar:(BOOL)prefix;

-(BOOL) addSinceToComments;
-(void) setAddSinceToComments:(BOOL)add;

-(BOOL) useHeaderDoc;
-(void) setUseHeaderDoc:(BOOL)use;

-(NSString *) spacesString;

@end
