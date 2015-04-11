//
//  ViewController.m
//  CxTouchTracker
//
//  Created by 成鑫 on 15/4/11.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import "CxDrawViewController.h"
#import "CxDrawView.h"

@interface CxDrawViewController ()

@end

@implementation CxDrawViewController

- (void)loadView
{
    self.view = [[CxDrawView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
