//
//  ViewController.m
//  LXMQuicklyFix
//
//  Created by xingming on 2020/7/3.
//  Copyright © 2020 lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test:nil];
    
    self.view.backgroundColor = [UIColor redColor];
}

- (void)test:(NSString *)str {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:str forKey:@"str"];
}


@end
