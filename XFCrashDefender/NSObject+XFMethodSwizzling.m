//
//  NSObject+XFMethodSwizzling.m
//  RuntimeForCrash
//
//  Created by F on 2019/8/26.
//  Copyright © 2019 F. All rights reserved.
//

#import "NSObject+XFMethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (XFMethodSwizzling)

/**
 交换类方法
 
 @param originalSelector 原生方法的SEL
 @param swizzledSelector 交换方法的SEL
 @param targetClass 目标类
 */
+ (void)swizzledClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
    swizzledClassMethod(targetClass, originalSelector, swizzledSelector);
}

/**
 交换对象方法
 
 @param originalSelector 原生方法的SEL
 @param swizzledSelector 交换方法的SEL
 @param targetClass 目标类
 */
+ (void)swizzledInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
    swizzledInstanceMethod(targetClass, originalSelector, swizzledSelector);
}

/* 交换类方法 */
void swizzledClassMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/* 交换实例方法 */
void swizzledInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
