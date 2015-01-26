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


@interface FCLessonViewController ()<UITableViewDataSource,UITableViewDelegate,FCEditorViewControllerDelegate>

@end

@implementation FCLessonViewController{
    UITableView *_lessonTableView;
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
    return @"Lessons";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)currentLesson{
    return [[[FCCache defaultCache] objectForKey:FCCache_Key_CurrentLesson] integerValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==[[FCLessonContentManager defaultManager] maxLesson]) {
        return;
    }
    
    FCEditorViewController *edVC = [[FCEditorViewController alloc] init];
    edVC.lesson = [[FCLessonContentManager defaultManager] lesson:indexPath.row];
    edVC.mode = FCEditorMode_Lesson;
    edVC.delegate=self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:edVC animated:YES completion:^{
        
    }];
}

-(void)didPassLesson:(FCLesson *)lesson{
    [[FCCache defaultCache] setObject:@(lesson.lessonIndex+1) forKey:FCCache_Key_CurrentLesson];
    [[FCCache defaultCache] flush];
    [_lessonTableView reloadData];
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
