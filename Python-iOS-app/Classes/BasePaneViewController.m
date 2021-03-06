//
//  BasePaneViewController.m
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "BasePaneViewController.h"
#import "CRGradientNavigationBar.h"

@interface BasePaneViewController ()

@end

@implementation BasePaneViewController{
    UINavigationItem *_navigationItem;
    CRGradientNavigationBar *_navigationBar;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasOpenDrawer = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *firstColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    UIColor *secondColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    NSArray *colors = [NSArray arrayWithObjects:firstColor, secondColor, nil];
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:colors];
    
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    UILabel *titleview = [[UILabel alloc] init];
    titleview.text = self.title;
    titleview.textColor = [UIColor whiteColor];
    [titleview sizeToFit];
    item.titleView=titleview;
    _navigationItem = item;
    
    if (self.hasOpenDrawer) {
        UIBarButtonItem *drawer = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"drawer"] landscapeImagePhone:nil style:UIBarButtonItemStyleBordered target:self action:@selector(openDrawerClick)];
        item.leftBarButtonItem = drawer;
    }
    
    CRGradientNavigationBar *bar = [[CRGradientNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    [bar pushNavigationItem:item animated:YES];
    [self.view addSubview:bar];
    _navigationBar = bar;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(UINavigationItem *)navigationItem{
    return _navigationItem;
}

-(UINavigationBar *)navigationBar{
    return _navigationBar;
}

-(void)viewControllerWillShow{
    
}

-(void)openDrawerClick{
    [self.drawerController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:NO completion:nil];
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
