//
//  QuicklyFix.h
//  LXMQuicklyFix
//
//  Created by xingming on 2020/7/3.
//  Copyright © 2020 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXMQuicklyFix : NSObject
+ (instancetype)sharedInstance;

- (void)evaluate:(NSString *)jsString;

@end

NS_ASSUME_NONNULL_END
