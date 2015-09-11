//
//  VVDocumenterSetting.h
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-8-3.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VVDSinceOption) {
    VVDSinceOptionPlaceholder,
    VVDSinceOptionProjectVersion,
    VVDSinceOptionSpecificVersion,
};

extern NSString *const VVDDefaultTriggerString;
extern NSString *const VVDDefaultAuthorString;
extern NSString *const VVDDefaultDateInfomationFormat;

@interface VVDocumenterSetting : NSObject
+ (VVDocumenterSetting *)defaultSetting;

@property (readonly) BOOL useDvorakLayout;
@property (readonly) BOOL useWorkmanLayout;
@property BOOL useSpaces;
@property NSInteger spaceCount;
@property NSString *triggerString;
@property VVDSinceOption sinceOption;
@property BOOL prefixWithStar;
@property BOOL prefixWithSlashes;
@property BOOL addSinceToComments;
@property NSString *sinceVersion;
@property BOOL briefDescription;
@property BOOL useHeaderDoc;
@property BOOL blankLinesBetweenSections;
@property BOOL alignArgumentComments;
@property BOOL useAuthorInformation;
@property NSString *authorInformation;
@property BOOL useDateInformation;
@property NSString *dateInformationFormat;
@property (readonly) NSString *spacesString;
@end
