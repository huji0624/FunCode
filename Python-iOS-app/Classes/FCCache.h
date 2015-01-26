//
//  FCCache.h
//  Python-iOS-app
//
//  Created by user on 15-1-26.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSString *FCCache_Key_CurrentLesson = @"curlesson";

@interface FCCache : NSObject

+(instancetype)defaultCache;

- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;

//save to file.
-(void)flush;
@end
