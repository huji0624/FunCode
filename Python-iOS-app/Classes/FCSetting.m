//
//  FCSetting.m
//  Python-iOS-app
//
//  Created by user on 15-1-23.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCSetting.h"

static FCSetting *_instance = nil;

@implementation FCSetting


+(instancetype)defaultSetting{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FCSetting alloc] init];
    });
    return _instance;
}

@end
