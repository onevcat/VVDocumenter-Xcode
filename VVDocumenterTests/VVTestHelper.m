//
//  VVTestHelper.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-19.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVTestHelper.h"

@interface NSArray(vv_Removing)
-(NSArray*)arrayByRemovingObject:(id)obj;
@end

@implementation NSArray (vv_Removing)
-(NSArray*)arrayByRemovingObject:(id)obj
{
    NSArray* newArray = [NSArray array];
    NSUInteger indexOfObj = [self indexOfObject:obj];
    newArray = [self subarrayWithRange:NSMakeRange(0, indexOfObj)];
    newArray = [newArray arrayByAddingObjectsFromArray:[self subarrayWithRange:NSMakeRange(indexOfObj+1, self.count - indexOfObj-1)]];
    return newArray;
}
@end

static NSArray *_typeStrings;

@implementation VVTestHelper
+(NSArray *) testCodes
{
    NSArray *methods = @[@"+ (ADTransition *)nullTransition;",
                         @"   -    (BOOL) application: (UIApplication *) application  \n didFinishLaunchingWithOptions: (NSDictionary *) launchOptions;",
                         @"- (id)initWithDuration:(CFTimeInterval)duration sourceRect:(CGRect)sourceRect {"];
    
    NSArray *functions = @[@"void dosomething ( int x, int  y );",
                           @"int main(int argc, char *argv[]) \n {",
                           @"void  NoParamFunc();",
                           @"typeof void(^IBLShareSuccessBlock)(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, BOOL end);"];
    
    NSArray *properties = @[@"@property (nonatomic, copy ) NSString *code;",
                            @"    @property ( nonatomic, strong ) Miao* test;",
                            @"@property ( assign, strong ) int test;"];
    
    NSArray *macros = @[@"#define MAX(A,B)	({",
                        @"#define MIN(A,B)	((A) < (B) ? (A) : (B))",
                        @"#define ABS(A)	((A) < 0 ? (-(A)) : (A))"];
    
    NSArray *structs = @[@"struct Foo \n {",
                         @"   struct node {",
                         @"struct objc_object {"];
    
    NSArray *enums = @[@"typedef NS_ENUM {",
                       @"typedef NS_ENUM \n {",
                       @"  typedef   NS_ENUM{"];
    
    NSArray *unions = @[@"union {",
                        @" union \n {",
                        @" union{"];
    
    NSArray *others = @[@"options = options | NSRegularExpressionDotMatchesLineSeparators;",
                        @"if (resultUntilSemiColon && resultUntilBrace) {",
                        @"static dispatch_once_t once;"];

    NSArray *compileKeywords = @[@"@interface VVDocumenter : NSObject \n {",
                                 @"@interface SyntaxTests()\n@property (nonatomic, retain) NSArray* inputs;",
                                 @"@implementation SyntaxTests\n\n- (void)setUp\n{",
                                 @"@interface A (a)\n- (id) foo;"];
    
    return @[methods,functions,properties,macros,structs,enums,unions,others,compileKeywords];
}

+(NSArray *) uniformCodes
{
    NSArray *methods = @[@"+(ADTransition *)nullTransition;",
                         @"   -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;",
                         @"-(id)initWithDuration:(CFTimeInterval)duration sourceRect:(CGRect)sourceRect {"];
    
    NSArray *functions = @[@"void dosomething( int x, int  y );",
                           @"int main(int argc, char *argv[]){",
                           @"void  NoParamFunc();",
                           @"typeof void(^IBLShareSuccessBlock)(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, BOOL end);"];
    
    NSArray *properties = @[@"@property(nonatomic, copy )NSString *code;",
                            @"    @property( nonatomic, strong )Miao* test;",
                            @"@property( assign, strong )int test;"];

    NSArray *macros = @[@"#define MAX(A,B)({",
                        @"#define MIN(A,B)((A)<(B)?(A):(B))",
                        @"#define ABS(A)((A)< 0 ?(-(A)) :(A))"];

    NSArray *structs = @[@"struct Foo {",
                         @"   struct node {",
                         @"struct objc_object {"];
    
    NSArray *enums = @[@"typedef NS_ENUM {",
                       @"typedef NS_ENUM {",
                       @"  typedef   NS_ENUM{"];
    
    NSArray *unions = @[@"union {",
                        @" union {",
                        @" union{"];
    
    NSArray *others = @[@"options = options | NSRegularExpressionDotMatchesLineSeparators;",
                        @"if(resultUntilSemiColon && resultUntilBrace){",
                        @"static dispatch_once_t once;"];

    NSArray *compileKeywords = @[@"@interface VVDocumenter : NSObject {",
                                 @"@interface SyntaxTests()@property(nonatomic, retain)NSArray* inputs;",
                                 @"@implementation SyntaxTests -(void)setUp {",
                                 @"@interface A(a)-(id)foo;"];
    
    return @[methods,functions,properties,macros,structs,enums,unions,others,compileKeywords];
}

+(NSArray *) arrayOfExceptCodeType:(NSString *)type
{
    if (!_typeStrings) {
        //Save all type specify method names in NSString+VVSyntax
        _typeStrings = @[@"vv_isObjCMethod",
                         @"vv_isCFunction",
                         @"vv_isProperty",
                         @"vv_isMacro",
                         @"vv_isStruct",
                         @"vv_isEnum",
                         @"vv_isUnion",
                         @"vv_isComplieKeyword"];
    }
    
    return [_typeStrings arrayByRemovingObject:type];
}

+(BOOL) performSyntaxMethod:(NSString *)selectorString onString:(NSString *)codestring {
    SEL selector =NSSelectorFromString(selectorString);
    BOOL returnValue = NO;
    if ([codestring respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [[codestring class] instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:codestring];
        [invocation invoke];

        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}

@end
