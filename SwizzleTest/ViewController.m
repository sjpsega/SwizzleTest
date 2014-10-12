//
//  ViewController.m
//  SwizzleTest
//
//  Created by sjpsega on 14-9-17.
//  Copyright (c) 2014年 sjpsega. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+Swizzle.h"
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //调用NSArray+Swizzle中替换的方法
    NSArray *array = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    
    NSString *lastObject = [array lastObject];
    NSLog(@"lastObject reslut:%@",lastObject);
    
    NSString *lastObject2 = [array performSelector:@selector(xxx_lastObject) withObject:nil];
    NSLog(@"origin lastObject reslut:%@",lastObject2);
    
    NSLog(@"------------");
    
    //动态添加并修改方法
    IMP xxx_firstObjectIMP = imp_implementationWithBlock(^(id _self){
        id originNum = objc_msgSend(_self, @selector(xxx_firstObject));
        NSLog(@"***  xxx_firstObject ***");
        return originNum;
    });
    
    Class clz = [NSArray class];
    class_addMethod(clz, @selector(xxx_firstObject), xxx_firstObjectIMP, "@@:");
    
    method_exchangeImplementations(class_getInstanceMethod(clz, @selector(firstObject)), class_getInstanceMethod(clz, @selector(xxx_firstObject)));
    
    NSString *first = [array firstObject];
    NSLog(@"firstObject result:%@",first);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
