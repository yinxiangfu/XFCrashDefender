//
//  ViewController.m
//  XFCrashDefenderDemo
//
//  Created by F on 2019/8/26.
//  Copyright © 2019 F. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self class] performSelector:@selector(classTest)];
    [self performSelector:@selector(test)];
    
    NSDictionary *dic = @{@"key": @"value"};
    NSString *str = (NSString *)dic;
    if (str.length) {
        NSLog(@"111");
    }else{
        NSLog(@"222");
    }
}


@end
