//
//  FCSettingViewController.m
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCSettingViewController.h"
#import "FCSetting.h"

@interface FCSettingViewController ()

@end

@implementation FCSettingViewController{
    FXFormViewController *_fxViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat ey = CGRectGetMaxY(self.navigationBar.frame);
    _fxViewController = [[FXFormViewController alloc] init];
    _fxViewController.formController.form = [[FCSetting alloc] init];
    _fxViewController.view.frame = CGRectMake(0, ey, self.view.bounds.size.width, self.view.bounds.size.height-ey);
    [self.view addSubview:_fxViewController.view];
}

-(NSString *)title{
    return @"Setting";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
