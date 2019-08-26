//
//  NSObject+XFSelectorDefender.m
//  RuntimeForCrash
//
//  Created by F on 2019/8/26.
//  Copyright © 2019 F. All rights reserved.
//

#import "NSObject+XFSelectorDefender.h"
#import <objc/runtime.h>
#import "NSObject+XFMethodSwizzling.h"

@implementation NSObject (XFSelectorDefender)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //拦截 + (id)forwardingTargetForSelector:(SEL)aSelector
        [NSObject swizzledClassMethod:@selector(forwardingTargetForSelector:)
                           withMethod:@selector(xf_forwardingTargetForSelector:)
                            withClass:[NSObject class]];
        
        //拦截 - (id)forwardingTargetForSelector:(SEL)aSelector
        [NSObject swizzledInstanceMethod:@selector(forwardingTargetForSelector:)
                              withMethod:@selector(xf_forwardingTargetForSelector:)
                               withClass:[NSObject class]];
    });
}

//MARK: 找不到类方法的实现
+ (id)xf_forwardingTargetForSelector:(SEL)aSelector {
    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    Method root_forwarding_Method = class_getClassMethod([NSObject class], forwarding_sel);
    Method curr_forwarding_Method = class_getClassMethod([self class], forwarding_sel);
    IMP root_forwarding_imp = method_getImplementation(root_forwarding_Method);
    IMP curr_forwarding_imp = method_getImplementation(curr_forwarding_Method);
    
    BOOL realize = root_forwarding_imp != curr_forwarding_imp;
    
    if (!realize) {
        //未实现第二步：备用接受者（消息接受者重定向）
        
        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
        Method root_methodSignature_sel = class_getClassMethod([NSObject class], methodSignature_sel);
        Method curr_methodSignature_sel = class_getClassMethod([self class], methodSignature_sel);
        IMP root_methodSignature_imp = method_getImplementation(root_methodSignature_sel);
        IMP curr_methodSignature_imp = method_getImplementation(curr_methodSignature_sel);
        
        realize = root_methodSignature_imp != curr_methodSignature_imp;
        if (!realize) {
            //未实现第三步：完整转发（消息重定向）
            
            NSString *errClassName = NSStringFromClass([self class]);
            NSString *errSel = NSStringFromSelector(aSelector);
            NSLog(@"%@ 的 %@ 方法出错", errClassName, errSel);
            
            //处理crash的类
            NSString *className = @"XFCrashClass";
            Class class = NSClassFromString(className);
            
            if (!class) {
                //如果不存在，则动态创建一个类
                Class superClass = [NSObject class];
                class = objc_allocateClassPair(superClass, className.UTF8String, 0);
                //注册类
                objc_registerClassPair(class);
            }
            
            if (!class_getInstanceMethod(class, aSelector)) {
                //如果类没有对应的方法，则动态添加一个
                class_addMethod(class, aSelector, (IMP)Crash, "i@:");
            }
            
            return [[class alloc] init];
        }
    }
    
    return [self xf_forwardingTargetForSelector:aSelector];
}

//MARK: 找不到对象方法的实现
- (id)xf_forwardingTargetForSelector:(SEL)aSelector {
    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    Method root_forwarding_Method = class_getInstanceMethod([NSObject class], forwarding_sel);
    Method curr_forwarding_Method = class_getInstanceMethod([self class], forwarding_sel);
    IMP root_forwarding_imp = method_getImplementation(root_forwarding_Method);
    IMP curr_forwarding_imp = method_getImplementation(curr_forwarding_Method);
    
    BOOL realize = root_forwarding_imp != curr_forwarding_imp;
    
    if (!realize) {
        //未实现第二步：备用接受者（消息接受者重定向）
        
        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
        Method root_methodSignature_sel = class_getInstanceMethod([NSObject class], methodSignature_sel);
        Method curr_methodSignature_sel = class_getInstanceMethod([self class], methodSignature_sel);
        IMP root_methodSignature_imp = method_getImplementation(root_methodSignature_sel);
        IMP curr_methodSignature_imp = method_getImplementation(curr_methodSignature_sel);
        
        realize = root_methodSignature_imp != curr_methodSignature_imp;
        if (!realize) {
            //未实现第三步：完整转发（消息重定向）
            
            NSString *errClassName = NSStringFromClass([self class]);
            NSString *errSel = NSStringFromSelector(aSelector);
            NSLog(@"%@ 的 %@ 方法出错", errClassName, errSel);
            
            //处理crash的类
            NSString *className = @"XFCrashClass";
            Class class = NSClassFromString(className);
            
            if (!class) {
                //如果不存在，则动态创建一个类
                Class superClass = [NSObject class];
                class = objc_allocateClassPair(superClass, className.UTF8String, 0);
                //注册类
                objc_registerClassPair(class);
            }
            
            if (!class_getInstanceMethod(class, aSelector)) {
                //如果类没有对应的方法，则动态添加一个
                class_addMethod(class, aSelector, (IMP)Crash, "i@:");
            }
            
            return [[class alloc] init];
        }
    }
    
    return [self xf_forwardingTargetForSelector:aSelector];
}

static int Crash(id self, SEL _cmd) {
    return 0;
}

@end
