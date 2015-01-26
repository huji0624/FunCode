//
//  FCCache.m
//  Python-iOS-app
//
//  Created by user on 15-1-26.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCCache.h"

static FCCache *_instance = nil;

@implementation FCCache{
    NSMutableDictionary *_cache;
}

+(instancetype)defaultCache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FCCache alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary dictionary];
        NSDictionary *tmp = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
        if (tmp) {
             [_cache setDictionary:tmp];
        }
    }
    return self;
}

-(NSString*)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootDocDir = [paths objectAtIndex:0];
    return [rootDocDir stringByAppendingPathComponent:@"defaultcache.plist"];
}

-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    [_cache setObject:anObject forKey:aKey];
}

-(id)objectForKey:(id)aKey{
    return [_cache objectForKey:aKey];
}

-(void)flush{
    [_cache writeToFile:[self filePath] atomically:YES];
}
@end
