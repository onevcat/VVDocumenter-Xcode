//
//  VVDocumenter.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVDocumenter : NSObject
-(id) initWithCode:(NSString *)code;
-(NSString *) baseIndentation;
-(NSString *) document;
@end
