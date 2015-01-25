//
//  FCLessonContentManager.h
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCLessonContentManager : NSObject
+(instancetype)defaultManager;

-(void)deployPackingLesson;

-(NSURL*)loadRootHtmlPage:(NSString*)name;

@end
