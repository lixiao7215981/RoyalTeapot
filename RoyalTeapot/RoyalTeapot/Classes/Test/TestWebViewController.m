//
//  TestWebViewController.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/12.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "TestWebViewController.h"
#import <NSObject+JSONCategories.h>
#import <MQTTSession.h>

@interface TestWebViewController ()<UIWebViewDelegate,MQTTSessionDelegate>
{
    SkywareResult *_result;
    MQTTSession *_secction;
    SkywareJSApiTool *_jsApiTool;
}

@end

@implementation TestWebViewController

static NSString * const MAC = @"ACCF234DAF0E";

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.displayNav = YES;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://w.webbig.cn/democeshi/shuihu.html"]]];
    
    _jsApiTool = [[SkywareJSApiTool alloc] init];
    
    
    
    // 订阅MQTT
    [self connectMQTTWithMAC];
    
    __block typeof(self.webView) web = self.webView;
    [self setRightBtnWithImage:nil orTitle:@"刷新" ClickOption:^{
        [web reload];
    }];
    
    [kNotificationCenter addObserver:self selector:@selector(connectMQTTWithMAC) name:kApplicationDidBecomeActive object:nil];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{    //查询设备信息
    [_jsApiTool queryDeviceInfoToWebView:webView];
    [SVProgressHUD dismiss];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [_jsApiTool JSApiSubStringRequestWith:request];
}

// 订阅MQTT
- (void)connectMQTTWithMAC
{
    _secction = [[MQTTSession alloc] initWithClientId:@"SkywareWebController"];
    [_secction setDelegate:self];
    [_secction connectAndWaitToHost:kMQTTServerHost port:1883 usingSSL:NO];
    [_secction subscribeToTopic:kTopic(MAC) atLevel:MQTTQosLevelAtLeastOnce];
}

#pragma mark - MQTT ----Delegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid
{
    [_jsApiTool onRecvDevStatusData:data ToWebView:self.webView];
}


@end
