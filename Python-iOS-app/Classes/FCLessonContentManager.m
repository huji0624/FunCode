//
//  FCLessonContentManager.m
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCLessonContentManager.h"
static FCLessonContentManager *_instance = nil;
@implementation FCLessonContentManager
+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FCLessonContentManager alloc] init];
    });
    return _instance;
}

-(void)deployPackingLesson{
    
}

-(NSString*)rootDirPath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *rootDocDir = [paths objectAtIndex:0];
    NSString *rootDocDir = [[NSBundle mainBundle] bundlePath];
    return [rootDocDir stringByAppendingPathComponent:@"WebResource"];
}

-(NSURL *)loadRootHtmlPage:(NSString *)name{
    NSString *path = [[[self rootDirPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"html"];
    NSURL *url = [NSURL URLWithString:path];
    return url;
}

@end
