//
//  FCAboutViewController.m
//  Python-iOS-app
//
//  Created by user on 15-3-6.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCAboutViewController.h"

@interface FCAboutViewController ()

@end

@implementation FCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat c = 242.0f/256.0f;
    [self.view setBackgroundColor:[UIColor colorWithRed:c green:c blue:c alpha:1.0f]];
    
    UIImageView *pythonLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"python.png"]];
    pythonLogo.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3);
    [self.view addSubview:pythonLogo];
    
    UILabel *pythonVersion = [[UILabel alloc] init];
    pythonVersion.text=NSLocalizedString(@"python", nil);
    pythonVersion.textColor=[UIColor grayColor];
    pythonVersion.backgroundColor=[UIColor clearColor];
    [pythonVersion sizeToFit];
    pythonVersion.center = CGPointMake(pythonLogo.center.x, CGRectGetMaxY(pythonLogo.frame)+CGRectGetHeight(pythonVersion.frame)/2);
    [self.view addSubview:pythonVersion];
    
    UILabel *contact = [[UILabel alloc] init];
    contact.backgroundColor=[UIColor clearColor];
    contact.text=@"huji0624@gmail.com";
    contact.textColor=[UIColor grayColor];
    [contact sizeToFit];
    contact.center=CGPointMake(pythonVersion.center.x, CGRectGetMaxY(pythonVersion.frame)+100);
    [self.view addSubview:contact];
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
