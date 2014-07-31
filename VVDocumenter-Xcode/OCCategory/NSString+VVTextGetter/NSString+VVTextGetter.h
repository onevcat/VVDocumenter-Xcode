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

-(VVTextResult *) vv_textResultOfCurrentLineCurrentLocation:(NSInteger)location;

-(VVTextResult *) vv_textResultOfPreviousLineCurrentLocation:(NSInteger)location;

-(VVTextResult *) vv_textResultOfNextLineCurrentLocation:(NSInteger)location;

-(VVTextResult *) vv_textResultUntilNextString:(NSString *)findString currentLocation:(NSInteger)location;

-(VVTextResult *) vv_textResultWithPairOpenString:(NSString *)open
                                      closeString:(NSString *)close
                                  currentLocation:(NSInteger)location;

-(VVTextResult *) vv_textResultMatchPartWithPairOpenString:(NSString *)open
                                            closeString:(NSString *)close
                                        currentLocation:(NSInteger)location;
@end
