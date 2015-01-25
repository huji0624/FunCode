//
//  FCMenuViewController.h
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSDynamicsDrawerViewController.h>
@interface FCMenuViewController : UITableViewController
@property (nonatomic,weak) MSDynamicsDrawerViewController *drawerController;

-(void)codeClick;
@end
