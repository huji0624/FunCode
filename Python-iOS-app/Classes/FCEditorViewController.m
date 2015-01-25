//
//  FCEditorViewController.m
//  Python-iOS-app
//
//  Created by user on 15-1-23.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCEditorViewController.h"
#import "PythonRun.h"
#include "Python.h"
#include "MBProgressHUD.h"
#include "AMSmoothAlertView.h"

@interface FCEditorViewController ()

@end

@implementation FCEditorViewController{
    UITextView *_editorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    UIBarButtonItem *runBI = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStyleBordered target:self action:@selector(runClick)];
    UIBarButtonItem *clearBI = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearClick)];
    
    self.navigationItem.rightBarButtonItems = @[clearBI,runBI];
    
    CGFloat ey = CGRectGetMaxY(self.navigationBar.frame);
    _editorView = [[UITextView alloc] initWithFrame:CGRectMake(0, ey, self.view.bounds.size.width, self.view.bounds.size.height - ey )];
    _editorView.editable=YES;
    _editorView.font = [UIFont systemFontOfSize:23];
    [self.view addSubview:_editorView];
}

-(NSString *)title{
    return @"Python";
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (Py_IsInitialized()==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading Python";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //init python
            //get python lib path and set this path as python home directory
            NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"python" ofType:nil inDirectory:nil];
            char home[1024];
            strcpy(home, [fullpath UTF8String]);
            
            Py_SetPythonHome(home);
            Py_Initialize();
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
        });
    }
   
}

-(void)clearClick{
    _editorView.text = @"";
}

-(void)runClick{
    [_editorView resignFirstResponder];
    
    PythonRun *run = [[PythonRun alloc] initWithCode:_editorView.text];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Running Python";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString* info = [run run];
        NSString* err = [run err];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            
            if (err) {
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Oops!" andText:err andCancelButton:NO forAlertType:AlertFailure];
                [alert show];
            }else{
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"OutPut:" andText:info andCancelButton:NO forAlertType:AlertInfo];
                [alert show];
            }
        });
    });
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
