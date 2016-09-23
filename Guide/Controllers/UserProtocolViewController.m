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
//    self.webView.delegate = self;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlCont;
    
    if (self.index == 0) {
       self.title = @"用户协议";
        
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"agreement-zl"
                                                              ofType:@"html"];
        htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        
    }else {
        self.title = @"使用指南";
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"guide-zl"
                                                              ofType:@"html"];
        htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                             encoding:NSUTF8StringEncoding
                                                error:nil];
    }

    
     [self.webView loadHTMLString:htmlCont baseURL:baseURL];
}

//#pragma mark UIWebViewDelegate
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//
//    [[HUDConfig shareHUD]alwaysShow];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//
//    [[HUDConfig shareHUD]dismiss];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//
//    [[HUDConfig shareHUD]dismiss];
//}

@end
