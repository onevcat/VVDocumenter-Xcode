//
//  VVTextResult.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 14-7-31.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVTextResult : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, copy) NSString *string;

-(instancetype) initWithRange:(NSRange)aRange string:(NSString *)aString;

@end
