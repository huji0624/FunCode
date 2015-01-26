//
//  FCEditorViewController.h
//  Python-iOS-app
//
//  Created by user on 15-1-23.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//
#import "BasePaneViewController.h"
#import "FCLesson.h"

typedef NS_ENUM(NSInteger, FCEditorMode) {
    FCEditorMode_Free = 0,
    FCEditorMode_Lesson,
};

@interface FCEditorViewController : BasePaneViewController
@property (nonatomic,assign) FCEditorMode mode;
@property (nonatomic,strong) FCLesson *lesson;
@end
