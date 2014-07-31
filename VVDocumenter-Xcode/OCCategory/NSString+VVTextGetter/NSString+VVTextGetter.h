//
//  NSString+VVTextGetter.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 14-7-31.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVTextResult;

@interface NSString (VVTextGetter)

-(VVTextResult *) textResultOfCurrentLineCurrentLocation:(NSInteger)location;

-(VVTextResult *) textResultOfPreviousLineCurrentLocation:(NSInteger)location;

-(VVTextResult *) textResultOfNextLineCurrentLocation:(NSInteger)location;

-(VVTextResult *) textResultUntilNextString:(NSString *)findString currentLocation:(NSInteger)location;

-(VVTextResult *) textResultWithPairOpenString:(NSString *)open
                                   closeString:(NSString *)close
                               currentLocation:(NSInteger)location;

-(VVTextResult *) textResultMatchPartWithPairOpenString:(NSString *)open
                                            closeString:(NSString *)close
                                        currentLocation:(NSInteger)location;
@end
