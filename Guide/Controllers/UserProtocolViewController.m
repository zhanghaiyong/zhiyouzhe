//
//  UserProtocolViewController.m
//  Guide
//
//  Created by ksm on 16/6/3.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UserProtocolViewController

//- (void)viewDidAppear:(BOOL)animated{
//
//    [super viewDidAppear:animated];
//
//    self.hidesBottomBarWhenPushed = NO;
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear:animated];
//    
//    self.hidesBottomBarWhenPushed = YES;
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = backgroudColor;
    
    [self setNavigationLeft:@"icon_back_iphone"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.webView.delegate = self;
    NSURL *url;
    if (self.index == 0) {
       self.title = @"用户协议";
        
        url = [NSURL URLWithString:@"http://m.zhiliaoguide.com:8080/zyz/agreement-zl.html"];
        
    }else {
        self.title = @"使用指南";
        url = [NSURL URLWithString:@"http://m.zhiliaoguide.com:8080/zyz/guide-zl.html"];
    }

    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {

    [[HUDConfig shareHUD]alwaysShow];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [[HUDConfig shareHUD]dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [[HUDConfig shareHUD]dismiss];
}

@end
