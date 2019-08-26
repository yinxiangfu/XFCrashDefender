//
//  NSObject+XFMethodSwizzling.h
//  RuntimeForCrash
//
//  Created by F on 2019/8/26.
//  Copyright © 2019 F. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XFMethodSwizzling)

/**
 交换类方法
 
 @param originalSelector 原生方法的SEL
 @param swizzledSelector 交换方法的SEL
 @param targetClass 目标类
 */
+ (void)swizzledClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;

/**
 交换对象方法
 
 @param originalSelector 原生方法的SEL
 @param swizzledSelector 交换方法的SEL
 @param targetClass 目标类
 */
+ (void)swizzledInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;

@end

NS_ASSUME_NONNULL_END
