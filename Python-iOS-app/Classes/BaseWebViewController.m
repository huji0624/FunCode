//
//  BaseWebViewController.m
//  Python-iOS-app
//
//  Created by huji on 15-1-25.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "BaseWebViewController.h"
#import <MBProgressHUD.h>
#import "FCLessonContentManager.h"

@interface BaseWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat ey = CGRectGetMaxY(self.navigationBar.frame);
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ey, self.view.bounds.size.width, self.view.bounds.size.height - ey )];
    self.webView.delegate = self;
    self.webView.opaque = YES;
    [self.view addSubview:self.webView];
}

-(void)loadURL:(NSURL *)url{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *hs = [NSString stringWithContentsOfFile:[url absoluteString] encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:hs baseURL:[[FCLessonContentManager defaultManager] baseURL]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",[error description]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
