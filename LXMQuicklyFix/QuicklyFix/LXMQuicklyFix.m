//
//  QuicklyFix.m
//  LXMQuicklyFix
//
//  Created by xingming on 2020/7/3.
//  Copyright © 2020 lin. All rights reserved.
//

#import "QuicklyFix.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "QuicklyFixConst.h"
#import "Aspects.h"
#import <objc/runtime.h>

@interface QuicklyFix()
@property (nonatomic,strong)JSContext *jsContext;
@end

@implementation QuicklyFix
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QuicklyFix *instance;
    dispatch_once(&onceToken, ^{
        instance = [[QuicklyFix alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _jsContext = [[JSContext alloc] init];
        _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            
        };
        [self initialize];
    }
    return self;
}


- (void)evaluate:(NSString *)jsString {
    if (jsString != nil && jsString.length > 0) {
        [self.jsContext evaluateScript:jsString];
    }
}


- (void)fixWithMethod:(BOOL)isClassMethod aspectionOptions:(AspectOptions)aspectionOptions instanceName:(NSString *)instanceName selectorName:(NSString *)selectorName fixImp:(JSValue *)fixImp {
    Class klass = NSClassFromString(instanceName);
    if (isClassMethod) {
        klass = object_getClass(klass);
    }
    SEL sel = NSSelectorFromString(selectorName);
    [klass aspect_hookSelector:sel withOptions:aspectionOptions usingBlock:^(id<AspectInfo> aspectInfo){
        [fixImp callWithArguments:@[aspectInfo.instance, aspectInfo.originalInvocation, aspectInfo.arguments]];
    } error:nil];
}


- (void)initialize {
    
    __weak typeof(self) weakSelf = self;
    self.jsContext[QuicklyFixConstReplaceInstanceMethod] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [weakSelf fixWithMethod:NO aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImp:fixImpl];
    };
    
    [self jsContext][@"runInvocation"] = ^(NSInvocation *invocation) {
        [invocation invoke];
    };
    [[self jsContext] evaluateScript:@"var console = {}"];
    [self jsContext][@"console"][@"log"] = ^(id message) {
        NSLog(@"Javascript log: %@",message);
    };
}

@end
