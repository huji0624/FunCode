//
//  FCAdManager.h
//  Python-iOS-app
//
//  Created by user on 15-3-5.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCAdManager : NSObject

+(instancetype)defaultManager;

- (void)initGADBannerWithAdPositionAtTop:(BOOL)isAdPositionAtTop;

-(void)showBannerView;
-(void)hideBannerView;

-(void)showScreenAD;
@end
