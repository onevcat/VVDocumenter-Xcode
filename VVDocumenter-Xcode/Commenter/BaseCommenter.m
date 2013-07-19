//
//  BaseCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "BaseCommenter.h"
#import "Argument.h"

@implementation BaseCommenter
-(id) initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    self = [super init];
    if (self) {
        self.indent = indent;
        self.code = code;
        self.arguments = [NSMutableArray array];
    }
    return self;
}

-(NSString *) startComment
{
    return [NSString stringWithFormat:@"%@/**\n%@ *\t@brief\t<#%@#>",self.indent,self.indent,@"Description"];
}

-(NSString *) argumentsComment
{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    for (Argument *arg in self.arguments) {
        if (result.length == 0) {
            [result appendFormat:@"%@ *\n",self.indent];
        } else {
            [result appendFormat:@"%@ *\t@param \t"];
        }
    }
    
}

-(NSString *) document
{
    NSLog(@"Miao");
    NSLog(@"%@",[self startComment]);
    return nil;
}
@end
