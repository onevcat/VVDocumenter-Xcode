//
//  VVDocumenterSetting.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-8-3.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVDocumenterSetting.h"

NSString *const VVDDefaultTriggerString = @"///";

NSString *const kVVDUseSpaces = @"com.onevcat.VVDocumenter.useSpaces";
NSString *const kVVDSpaceCount = @"com.onevcat.VVDocumenter.spaceCount";
NSString *const kVVDTriggerString = @"com.onevcat.VVDocumenter.triggerString";

@implementation VVDocumenterSetting

+ (VVDocumenterSetting *)defaultSetting
{
    static dispatch_once_t once;
    static VVDocumenterSetting *defaultSetting;
    dispatch_once(&once, ^ { defaultSetting = [[VVDocumenterSetting alloc] init]; });
    return defaultSetting;
}

-(BOOL) useSpaces
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVVDUseSpaces];
}

-(void) setUseSpaces:(BOOL)useSpace
{
    [[NSUserDefaults standardUserDefaults] setBool:useSpace forKey:kVVDUseSpaces];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSInteger) spaceCount
{
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:kVVDSpaceCount];
    return (count <= 0) ? 4 : count;
}

-(void) setSpaceCount:(NSInteger)spaceCount
{
    if (spaceCount < 1) {
        spaceCount = 1;
    } else if (spaceCount > 10) {
        spaceCount = 10;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:spaceCount forKey:kVVDSpaceCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *) triggerString
{
    NSString *s = [[NSUserDefaults standardUserDefaults] stringForKey:kVVDTriggerString];
    if (s.length == 0) {
        s = VVDDefaultTriggerString;
    }
    return s;
}

-(void) setTriggerString:(NSString *)triggerString
{
    if (triggerString.length == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:VVDDefaultTriggerString forKey:kVVDTriggerString];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:triggerString forKey:kVVDTriggerString];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *) spacesString
{
    if ([self useSpaces]) {
        return [@"" stringByPaddingToLength:[self spaceCount] withString:@" " startingAtIndex:0];
    } else {
        return @"\t";
    }
}

@end
