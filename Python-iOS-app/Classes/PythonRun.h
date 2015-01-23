//
//  PythonRun.h
//  Python-iOS-app
//
//  Created by user on 15-1-23.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PythonRun : NSObject
-(instancetype)initWithCode:(NSString*)code;
-(NSString*)run;
-(NSString*)err;
@end
