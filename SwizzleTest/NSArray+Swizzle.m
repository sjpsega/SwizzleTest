//
//  NSArray+SJP_Swizzle.m
//  SwizzleTest
//
//  Created by sjpsega on 14-9-17.
//  Copyright (c) 2014年 sjpsega. All rights reserved.
//

#import "NSArray+Swizzle.h"
#import <objc/runtime.h>

@implementation NSArray (Swizzle)

+(void)load{
    NSLog(@"load");
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(lastObject);
        SEL swizzledSelector = @selector(xxx_lastObject);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (id)xxx_lastObject{
    id ret = [self xxx_lastObject];
    NSLog(@"************* xxx_lastObject *******");
    return ret;
}
@end
