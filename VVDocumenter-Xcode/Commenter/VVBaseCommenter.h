//
//  VVBaseCommenter.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVBaseCommenter : NSObject

@property (nonatomic, copy) NSString *indent;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSMutableArray *arguments;
@property (nonatomic, assign) BOOL hasReturn;

-(instancetype) initWithIndentString:(NSString *)indent codeString:(NSString *)code;

-(NSString *) document;

-(NSString *) documentForC;
-(NSString *) documentForSwift;
-(NSString *) documentForSwiftEnum;

-(void) parseArgumentsInputArgs:(NSString *)rawArgsCode;

-(BOOL) shouldComment;

// Comment methods
-(NSString *) startComment;
-(NSString *) argumentsComment;
-(NSString *) endComment;
-(NSString *) returnComment;
-(NSString *) sinceComment;

@end
