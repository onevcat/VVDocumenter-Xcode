//
//  NSString+VVSyntax.h
//  CommentTest
//
//  Created by 王 巍 on 13-7-18.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VVSyntax)
-(NSString *) vv_stringByConvertingToUniform;
-(NSString *) vv_stringByTrimEndSpaces;

-(BOOL) vv_isObjCMethod;
-(BOOL) vv_isProperty;
-(BOOL) vv_isCFunction;
-(BOOL) vv_isMacro;
-(BOOL) vv_isEnum;
-(BOOL) vv_isStruct;
-(BOOL) vv_isUnion;
-(BOOL) vv_isComplieKeyword;
@end