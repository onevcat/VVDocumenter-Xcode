//
//  VVSwiftExtensionCommenter.m
//  VVDocumenter-Xcode
//
//  Created by WANG WEI on 2015/06/17.
//  Copyright (c) 2015年 OneV's Den. All rights reserved.
//

#import "VVSwiftExtensionCommenter.h"

@implementation VVSwiftExtensionCommenter
-(NSString *) document
{
    NSArray *component = [[self.code stringByReplacingOccurrencesOfString:@"{" withString:@""] componentsSeparatedByString:@":"];
    NSString *description = @"Description";
    if (component.count == 2) {
        description = [component.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    return [NSString stringWithFormat:@"// MARK: - <#%@#>", description];
}
@end
