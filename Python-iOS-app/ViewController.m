//
//  ViewController.m
//  Python-iOS-app
//
//  Created by Fancyzero on 13-8-21.
//  Copyright (c) 2013年 Fancyzero. All rights reserved.
//

#import "ViewController.h"
#import "MSDynamicsDrawerViewController.h"
#import "FCMenuViewController.h"

@interface ViewController ()
@property (nonatomic,strong) MSDynamicsDrawerViewController *drawerController;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.drawerController = [[MSDynamicsDrawerViewController alloc] init];
    self.drawerController.gravityMagnitude = 7.0f;
    self.drawerController.elasticity = 0.0f;
    self.drawerController.bounceElasticity = 0.0f;
    [self.view addSubview:self.drawerController.view];
    
    [self.drawerController addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    
    FCMenuViewController *menuVC = [[FCMenuViewController alloc] init];
    menuVC.drawerController = self.drawerController;
    [self.drawerController setDrawerViewController:menuVC forDirection:MSDynamicsDrawerDirectionLeft];
    
    [menuVC lessonClick];
}

-(void)viewDidAppear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
