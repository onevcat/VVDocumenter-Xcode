//
//  VVTestHelper.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-19.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVTestHelper : NSObject
+(NSArray *) testCodes;
+(NSArray *) uniformCodes;

+(NSArray *) arrayOfExceptCodeType:(NSString *)type;
+(BOOL) performSyntaxMethod:(NSString *)selectorString onString:(NSString *)codestring;
@end
