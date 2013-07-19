//
//  NSString+VVSyntax.h
//  CommentTest
//
//  Created by 王 巍 on 13-7-18.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VVSyntax)
-(NSString *) stringByConvertingToUniform;

-(BOOL) isObjCMethod;
-(BOOL) isProperty;
-(BOOL) isCFunction;
-(BOOL) isMacro;
-(BOOL) isEnum;
-(BOOL) isStruct;
-(BOOL) isUnion;
@end
