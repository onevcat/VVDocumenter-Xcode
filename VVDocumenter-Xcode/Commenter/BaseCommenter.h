//
//  BaseCommenter.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCommenter : NSObject

@property (nonatomic, copy) NSString *indent;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, retain) NSMutableArray *arguments;
@property (nonatomic, assign) BOOL hasReturn;

-(id) initWithIndentString:(NSString *)indent codeString:(NSString *)code;
-(NSString *) document;
@end
