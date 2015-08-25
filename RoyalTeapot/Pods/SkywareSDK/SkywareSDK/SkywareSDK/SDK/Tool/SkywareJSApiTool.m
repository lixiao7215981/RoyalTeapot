//
//  SkywareJSApiTool.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/14.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareJSApiTool.h"

@implementation SkywareJSApiTool

/**
 *  拦截WebView的请求,截取请求获得相应的处理
 *
 *  @param request 请求的 Request
 *
 *  @return 是否允许WebView 继续加载操作
 */
- (BOOL) JSApiSubStringRequestWith:(NSURLRequest *) request
{
    NSString *urlStr = request.URL.absoluteString;
    NSRange range = [urlStr rangeOfString:@"jsapi"];
    if (range.location != NSNotFound) {
        NSArray *urlArray = [urlStr componentsSeparatedByString:@"/"];
        NSInteger count = urlArray.count;
        [urlArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
            if ([str isEqualToString:@"sendCmdToDevice"]) { // 发送指令给设备
                SkywareSendCmdModel *sendModel = [[SkywareSendCmdModel alloc]init];
                sendModel.sn = urlArray[count - 3];
                sendModel.mac = urlArray[count - 2];
                sendModel.commandv = [urlArray[count - 1] decodeFromPercentEscapeString];
                [self sendCmdToDeviceWith:sendModel];
                *stop = YES;
            }else if ([str isEqualToString:@"getBindDevicesInfo"]){
                // 获取设备列表，暂时忽略
            }
        }];
        return NO;
    }
    return YES;
}

/**
 *  MQTT 推送消息给 WebView
 *
 *  @param data    MQTT 推送的Data
 *  @param webView 推送到 WebView
 */
- (void) onRecvDevStatusData:(NSData *) data ToWebView:(UIWebView *) webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onRecvDevStatus('%@')",[data JSONString]]];
}

/**
 *  将错误信息推到 WebView
 *
 *  @param jsonStr JSON
 *  @param code    错误代码
 *  @param message 错误信息
 *  @param webView 推送到 WebView
 */
- (void) onSendCmdResultJsonStr:(NSString *) jsonStr Code:(NSString *) code Message:(NSString *) message ToWebView:(UIWebView *) webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onSendCmdResult('%@','%@','%@')",jsonStr,code,message]];
}

/**
 *  将设备信息推到 WebView
 *
 *  @param jsonStr JSOn
 *  @param code    错误代码
 *  @param message 错误信息
 *  @param webView 推送到 WebView
 */
- (void)onGotCurDevInfoJsonStr:(NSString *) jsonStr Code:(NSString *) code Message:(NSString *) message ToWebView:(UIWebView *) webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onGotCurDevInfo('%@','%@','%@')",jsonStr,code,message]];
}

/**
 *  发送指令到设备
 */
- (void) sendCmdToDeviceWith:(SkywareSendCmdModel *) send
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!instance) return;
    [params setObject: instance.device_id forKey:@"device_id"];
    [params setObject: send.commandv forKey:@"commandv"];
    [SkywareDeviceManagement DevicePushCMD:params Success:^(SkywareResult *result) {
        NSLog(@"指令发送成功---%@",params);
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        NSLog(@"指令发送失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 *  查询设备信息
 */
- (SkywareResult *)queryDeviceInfoToWebView:(UIWebView *) webView
{
    __block typeof(SkywareResult) *httpResult;
    SkywareDeviceQueryInfoModel *query = [[SkywareDeviceQueryInfoModel alloc] init];
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    query.id = instance.device_id;
    [SkywareDeviceManagement DeviceQueryInfo:query Success:^(SkywareResult *result) {
        httpResult = result;
        [self onGotCurDevInfoJsonStr:[result.result JSONString] Code:nil Message:nil ToWebView:webView];
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        httpResult  = nil;
    }];
    return httpResult;
}

@end
