//
//  FCMenuViewController.m
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCMenuViewController.h"
#import "BasePaneViewController.h"
#import "FCEditorViewController.h"
#import "BaseWebViewController.h"
#import "FCLessonContentManager.h"
#import "FCSettingViewController.h"
#import "FCLessonViewController.h"

@interface FCMenuViewController ()

@end

@implementation FCMenuViewController{
    NSArray *_rowArray;
    FCEditorViewController *_editorVC;
    FCLessonViewController *_lessonVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _rowArray = @[
                  @[@"Lesson",@"lessonClick"],
                  @[@"FreeCode",@"freeCodeClick"],
                  @[@"Setting",@"setClick"],
                  @[@"About",@"aboutClick"]
                ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)freeCodeClick{
    if (!_editorVC) {
        _editorVC = [[FCEditorViewController alloc] init];
    }
    [self setPaneViewController:_editorVC];
}

-(void)lessonClick{
    if (!_lessonVC) {
        _lessonVC = [[FCLessonViewController alloc] init];
    }
    [self setPaneViewController:_lessonVC];
}

-(void)setClick{
    [self setPaneViewController:[[FCSettingViewController alloc] init]];
}

-(void)aboutClick{
    BaseWebViewController *about = [[BaseWebViewController alloc] init];
    about.title = @"About";
    [self setPaneViewController:about];
    [about loadURL:[[FCLessonContentManager defaultManager] loadRootHtmlPage:@"about"]];
}

-(void)setPaneViewController:(BasePaneViewController*)vc{
    [self.drawerController setPaneViewController:vc];
    vc.drawerController = self.drawerController;
    if (self.drawerController.paneState != MSDynamicsDrawerPaneStateClosed) {
        [self.drawerController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:NO completion:nil];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cid = @"menu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    cell.textLabel.text = _rowArray[indexPath.row][0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selector = _rowArray[indexPath.row][1];
    SEL sel = NSSelectorFromString(selector);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rowArray.count;
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
