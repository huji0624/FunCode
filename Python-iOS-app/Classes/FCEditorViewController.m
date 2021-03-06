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
#import "MBProgressHUD.h"
#import "AMSmoothAlertView.h"
#import "FCSetting.h"
#import "FCLessonContentManager.h"
#import "FCAdManager.h"

@interface FCEditorViewController ()

@end

@implementation FCEditorViewController{
    UITextView *_editorView;
    UIWebView *_lessonWebView;
    UIView *_backGroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *runBI = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"run", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(runClick)];
    UIBarButtonItem *clearBI = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"clear", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clearClick)];
    
    self.navigationItem.rightBarButtonItems = @[clearBI,runBI];
    
    CGFloat ey = CGRectGetMaxY(self.navigationBar.frame);
    _editorView = [[UITextView alloc] initWithFrame:CGRectMake(0, ey, self.view.bounds.size.width, self.view.bounds.size.height - ey )];
    _editorView.editable=YES;
    _editorView.font = [UIFont systemFontOfSize:[[FCSetting alloc] init].editorFontSize];
    [self.view addSubview:_editorView];
    
    if (self.mode==FCEditorMode_Lesson) {
        [self layoutLessonViews];
    }
}

-(void)viewControllerWillShow{
    _editorView.font = [UIFont systemFontOfSize:[[FCSetting alloc] init].editorFontSize];
}

-(void)layoutLessonViews{
    UIBarButtonItem *backBI = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backClick)];
    UIBarButtonItem *lessonBI = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"lessons", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(lessonClick)];
    self.navigationItem.leftBarButtonItems = @[backBI,lessonBI];
    
    [self showLessonView:NO];
}

-(void)lessonClick{
    [self showLessonView:!_lessonWebView.hidden];
}

-(void)showLessonView:(BOOL)hidden{
    
    if (hidden) {
        _lessonWebView.hidden=YES;
        _backGroundView.hidden=YES;
    }else{
        if (_lessonWebView) {
            _lessonWebView.hidden=NO;
            _backGroundView.hidden=NO;
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = NSLocalizedString(@"loading", nil);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *err = nil;
                NSString *lesson_ = [NSString stringWithContentsOfFile:self.lesson.content.absoluteString encoding:NSUTF8StringEncoding error:&err];
                if (err) NSLog(@"%@",[err description]);
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    
                    if (!_lessonWebView) {
                        _backGroundView = [[UIView alloc] initWithFrame:_editorView.frame];
                        _backGroundView.backgroundColor = [UIColor blackColor];
                        _backGroundView.alpha = 0.3;
                        [self.view addSubview:_backGroundView];
                        CGSize size = _backGroundView.bounds.size;
                        _lessonWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width/6*5, size.height/5*4)];
                        [_lessonWebView loadHTMLString:lesson_ baseURL:[self.lesson.content URLByDeletingLastPathComponent]];
                        _lessonWebView.center = CGPointMake(CGRectGetMidX(_backGroundView.frame), CGRectGetMidY(_backGroundView.frame));
                        [self.view addSubview:_lessonWebView];
                    }
                    
                });
            });
        }
    }
}

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)title{
    if (self.mode==FCEditorMode_Lesson) {
        return [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"lessons", nil),@(self.lesson.lessonIndex)];
    }
    return @"Python";
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (Py_IsInitialized()==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString(@"loading", nil);
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
    
    if ([_editorView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString(@"loading", nil);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableString *allcode = [NSMutableString string];
        [allcode appendString:@"# -*- coding:utf8 -*-\n"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.lesson.inputPython.absoluteString]) {
            NSString *input = [NSString stringWithContentsOfFile:self.lesson.inputPython.absoluteString encoding:NSUTF8StringEncoding error:nil];
            [allcode appendString:input];
            [allcode appendString:@"\n"];
        }
        
        [allcode appendString:_editorView.text];
        
        PythonRun *run = [[PythonRun alloc] initWithCode:allcode];
        NSString* info = [run run];
        NSString* err = [run err];
        
        info = [info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *answer = [NSString stringWithContentsOfFile:self.lesson.outPutAnswer.absoluteString encoding:NSUTF8StringEncoding error:nil];
        if (!answer) {
            assert("no answer");
        }
        
        answer = [answer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            
            if (err) {
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:NSLocalizedString(@"oops", nil) andText:err andCancelButton:NO forAlertType:AlertFailure];
                alert.completionBlock = ^(AMSmoothAlertView *sal, UIButton *bt){
                    [[FCAdManager defaultManager] hideBannerView];
                };
                [alert show];
                
                [[FCAdManager defaultManager] showBannerView];
            }else{
                if (self.mode==FCEditorMode_Free) {
                    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:NSLocalizedString(@"output", nil) andText:info andCancelButton:NO forAlertType:AlertInfo];
                    alert.completionBlock = ^(AMSmoothAlertView *sal, UIButton *bt){
                        [[FCAdManager defaultManager] hideBannerView];
                    };
                    [alert show];
                    
                    [[FCAdManager defaultManager] showBannerView];
                }else if(self.mode==FCEditorMode_Lesson){
                    if ([info isEqualToString:answer]) {
                        AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:NSLocalizedString(@"yes", nil) andText:info andCancelButton:NO forAlertType:AlertSuccess];
                        alert.completionBlock = ^(AMSmoothAlertView *sal, UIButton *bt){
                            [self dismissViewControllerAnimated:YES completion:^{
                                [self.delegate didPassLesson:self.lesson];
                            }];
                        };
                        [alert show];
                    }else{
                        AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:NSLocalizedString(@"no", nil) andText:info andCancelButton:NO forAlertType:AlertInfo];
                        alert.completionBlock = ^(AMSmoothAlertView *sal, UIButton *bt){
                            [[FCAdManager defaultManager] hideBannerView];
                        };
                        [alert show];
                        
                        [[FCAdManager defaultManager] showBannerView];
                    }
                }else{
                    assert("not support mode.");
                }
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
