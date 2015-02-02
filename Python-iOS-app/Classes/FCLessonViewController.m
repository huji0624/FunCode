//
//  FCLessonViewController.m
//  Python-iOS-app
//
//  Created by user on 15-1-26.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCLessonViewController.h"
#import "FCCache.h"
#import "FCEditorViewController.h"
#import "FCLessonContentManager.h"
#import "BaseWebViewController.h"
#import "CCAlertView.h"
#import <StoreKit/StoreKit.h>

@interface FCLessonViewController ()<UITableViewDataSource,UITableViewDelegate,FCEditorViewControllerDelegate,SKStoreProductViewControllerDelegate>

@end

@implementation FCLessonViewController{
    UITableView *_lessonTableView;
    FCLesson *_currentLesson;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat ey = CGRectGetMaxY(self.navigationBar.frame);
    _lessonTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ey, self.view.bounds.size.width, self.view.bounds.size.height - ey ) style:UITableViewStyleGrouped];
    _lessonTableView.delegate=self;
    _lessonTableView.dataSource=self;
    [self.view addSubview:_lessonTableView];
    
    [_lessonTableView reloadData];
}

-(NSString *)title{
    return NSLocalizedString(@"lessons", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)currentLesson{
    return [[[FCCache defaultCache] objectForKey:FCCache_Key_CurrentLesson] integerValue];
}

-(void)goReview:(id)param{
    NSString *appId = nil;
    SKStoreProductViewController *reviewVC = [[SKStoreProductViewController alloc] init];
    if (reviewVC) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
        [reviewVC setDelegate:self];
        [reviewVC loadProductWithParameters:dic completionBlock:^(BOOL result, NSError *error) {
            if (!result) {
                [reviewVC dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"error loadProduct %@",error.localizedFailureReason);
            }
        }];
        [self presentViewController:reviewVC animated:YES completion:nil];
    }else{
        // before iOS6.0
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId]]];
    }
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==[[FCLessonContentManager defaultManager] maxLesson]) {
        CCAlertView *alert = [[CCAlertView alloc] initWithTitle:NSLocalizedString(@"review", nil) message:NSLocalizedString(@"reviewmsg", nil)];
        [alert addButtonWithTitle:NSLocalizedString(@"cancelbt", nil) block:nil];
        [alert addButtonWithTitle:NSLocalizedString(@"reviewconfirmbt", nil) block:^{
            //go review
            [self goReview:nil];
        }];
        [alert show];
        return;
    }
    
    FCLesson *lesson = [[FCLessonContentManager defaultManager] lesson:indexPath.row];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:lesson.outPutAnswer.absoluteString]) {
        FCEditorViewController *edVC = [[FCEditorViewController alloc] init];
        edVC.lesson = lesson;
        edVC.mode = FCEditorMode_Lesson;
        edVC.delegate=self;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:edVC animated:YES completion:^{
            
        }];
    }else{
        [self showLessonView:lesson];
    }
    
    _currentLesson = lesson;
}

-(void)showLessonView:(FCLesson*)lesson{
    
    BaseWebViewController *web = [[BaseWebViewController alloc] init];
    web.hasOpenDrawer=NO;
    web.title=[NSString stringWithFormat:@"Lesson %@",@(lesson.lessonIndex)];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:web animated:YES completion:^{
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(webBackClick)];
        UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(webNextClick)];
        web.navigationItem.leftBarButtonItem=back;
        web.navigationItem.rightBarButtonItem=next;
        [web loadURL:lesson.content];
    }];
}

-(void)webBackClick{
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)webNextClick{
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self didPassLesson:_currentLesson];
    }];
}

-(void)didPassLesson:(FCLesson *)lesson{
    if (lesson.lessonIndex==[self currentLesson]) {
        [[FCCache defaultCache] setObject:@(lesson.lessonIndex+1) forKey:FCCache_Key_CurrentLesson];
        [[FCCache defaultCache] flush];
        [_lessonTableView reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self currentLesson] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idf = @"lessonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idf];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idf];
    }
    if (indexPath.row==[[FCLessonContentManager defaultManager] maxLesson]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Waiting For More Lessons..."];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"Lesson %@",@(indexPath.row)];
    }
    return cell;
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
