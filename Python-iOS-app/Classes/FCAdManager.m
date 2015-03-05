//
//  FCAdManager.m
//  Python-iOS-app
//
//  Created by user on 15-3-5.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCAdManager.h"
#import "GADBannerViewDelegate.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "GADRequest.h"
#import "GADInterstitialDelegate.h"

#define ADMOB_UID @"a153a14e5305ecd"
#define ADMOB_SCREEN_UID @"ca-app-pub-9455502179330810/4512201681"

@interface FCAdManager ()<GADBannerViewDelegate,GADInterstitialDelegate>
{
    GADBannerView *bannerView_;
    BOOL isAdPositionAtTop_;
}

@property(nonatomic,strong) GADInterstitial *interstitial;

- (GADRequest *)createRequest;
//- (void)resizeViewsForOrientation:(UIInterfaceOrientation)toInt;

- (void)initScreenAD;

@end

static FCAdManager *instance_ = nil;

@implementation FCAdManager

+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[FCAdManager alloc] init];
    });
    return instance_;
}

-(void)showBannerView{
    bannerView_.hidden=NO;
}

-(void)hideBannerView{
    bannerView_.hidden=YES;
}

-(void)showScreenAD{
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    }
}

-(void)initScreenAD{
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = ADMOB_SCREEN_UID;
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[self createRequest]];
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    [self initScreenAD];
}

//GAD
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
//        request.testDevices =
//        [NSArray arrayWithObjects:
//         GAD_SIMULATOR_ID,
//         nil];
    return request;
}

- (void)initGADBannerWithAdPositionAtTop:(BOOL)isAdPositionAtTop {
    isAdPositionAtTop_ = isAdPositionAtTop;
    
    // NOTE:
    // Add your publisher ID here and fill in the GADAdSize constant for the ad
    // you would like to request.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView_.adUnitID = ADMOB_UID;
    bannerView_.delegate = self;
    [bannerView_ setRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:bannerView_];
    [bannerView_ loadRequest:[self createRequest]];
    
    bannerView_.hidden = YES;
}

#pragma mark GADBannerViewDelegate impl

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received banner ad");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive banner ad with error: %@", [error localizedFailureReason]);
}

-(void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    NSLog(@"Received Screen ad");
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"Failed to receive Screen ad with error: %@", [error localizedFailureReason]);
}

@end
