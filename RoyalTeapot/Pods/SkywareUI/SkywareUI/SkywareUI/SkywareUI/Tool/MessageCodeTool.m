//
//  MessageCodeTool.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/15.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "MessageCodeTool.h"
#import <SMS_SDK/SMS_SDK.h>

@implementation MessageCodeTool

+ (void)getMessageCodeWithPhone:(NSString *)phone Zone:(NSString *)zone Success:(void (^)())success Error:(void (^)(NSError *))failure
{
    [SMS_SDK getVerificationCodeBySMSWithPhone:phone zone:zone == nil? @"86":zone result:^(SMS_SDKError *SDKError) {
        if (!SDKError) {
            if (success) {
                success();
            }
        }else{
            if (failure) {
                failure(SDKError);
            }
        }
    }];
}

+ (void)commitVerifyCode:(NSString *)code Success:(void (^)())success Error:(void (^)())failure
{
    [SMS_SDK commitVerifyCode:code result:^(enum SMS_ResponseState state) {
        if (1==state){
            if (success) {
                success();
            }
        }else if(0==state){
            if (failure) {
                failure();
            }
        }
    }];
    
}


@end
