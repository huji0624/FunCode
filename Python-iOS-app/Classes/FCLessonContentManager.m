//
//  FCLessonContentManager.m
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCLessonContentManager.h"
static FCLessonContentManager *_instance = nil;
@implementation FCLessonContentManager{
    NSUInteger _max;
}
+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FCLessonContentManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
         NSArray *dc = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self rootLessonDir] error:nil];
        _max = dc.count;
    }
    return self;
}

-(NSUInteger)maxLesson{
    return _max;
}

-(void)deployPackingLesson{
    
}

-(FCLesson *)lesson:(NSUInteger)lesson{
    NSString *dirpath = [[self rootLessonDir] stringByAppendingFormat:@"/lesson%@",@(lesson)];
    FCLesson *les_ = [[FCLesson alloc] init];
    les_.lessonIndex = lesson;
    les_.content = [NSURL URLWithString:[dirpath stringByAppendingPathComponent:@"content.html"]];
    les_.inputPython = [NSURL URLWithString:[dirpath stringByAppendingPathComponent:@"input.py"]];
    les_.outPutAnswer = [NSURL URLWithString:[dirpath stringByAppendingPathComponent:@"output.txt"]];
    return les_;
}

-(NSString*)rootLessonDir{
    return [[self rootDirPath] stringByAppendingFormat:@"/lessons"];
}

-(NSString*)rootDirPath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *rootDocDir = [paths objectAtIndex:0];
    NSString *rootDocDir = [[NSBundle mainBundle] bundlePath];
    return [rootDocDir stringByAppendingPathComponent:@"WebResource/zh"];
}

-(NSURL *)loadRootHtmlPage:(NSString *)name{
    NSString *path = [[[self rootDirPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"html"];
    NSURL *url = [NSURL URLWithString:path];
    return url;
}

@end
