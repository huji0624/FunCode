//
//  FCLesson.h
//  Python-iOS-app
//
//  Created by user on 15-1-26.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCLesson : NSObject
@property (nonatomic,assign) NSUInteger lessonIndex;
@property (nonatomic,strong) NSURL *content;
@property (nonatomic,strong) NSURL *inputPython;
@property (nonatomic,strong) NSURL *outPutAnswer;
@end
