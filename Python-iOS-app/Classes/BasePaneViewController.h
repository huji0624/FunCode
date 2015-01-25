//
//  BasePaneViewController.h
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSDynamicsDrawerViewController.h>

@interface BasePaneViewController : UIViewController
@property (nonatomic,weak) MSDynamicsDrawerViewController *drawerController;
@property (nonatomic,readonly,strong) UINavigationBar *navigationBar;
@end
