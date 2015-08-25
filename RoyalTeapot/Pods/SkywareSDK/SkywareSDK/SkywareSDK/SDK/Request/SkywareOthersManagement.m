//
//  SkywareOthersManagement.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareOthersManagement.h"

@implementation SkywareOthersManagement

+ (void)UserAddressWeatherParamesers:(SkywareWeatherModel *)model Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    [SkywareHttpTool HttpToolPostWithUrl:Address_wpm paramesers:model.keyValues requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

@end
