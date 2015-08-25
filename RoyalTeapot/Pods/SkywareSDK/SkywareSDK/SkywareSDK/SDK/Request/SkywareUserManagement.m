//
//  SkywareUserManagement.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareUserManagement.h"

@implementation SkywareUserManagement

+ (void)UserVerifyLoginIdExistsWithLoginid:(NSString *)login_id Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSMutableArray *parameser = [NSMutableArray array];
    [parameser addObject:@(instance.app_id)];
    [parameser addObject:login_id];
    [SkywareHttpTool HttpToolGetWithUrl:UserCheckId paramesers:parameser requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure]; // message = 200 找到 = 已经注册过
    } failure:^(NSError *error) {
        
    }];
}

+ (void)UserGetUserWithParamesers:(NSArray *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolGetWithUrl:User paramesers:parameser requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)UserRegisterWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *result))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameser];
    [dict setObject: @(instance.app_id) forKey:@"app_id"];
    [SkywareHttpTool HttpToolPostWithUrl:UserRegisterURL paramesers:dict requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)UserLoginWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *result))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameser];
    [dict setObject: @(instance.app_id) forKey:@"app_id"];
    [SkywareHttpTool HttpToolPostWithUrl:UserLoginURL paramesers:dict requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)UserRetrievePasswordWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *result))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameser];
    [dict setObject: @(instance.app_id) forKey:@"app_id"];
    [SkywareHttpTool HttpToolPostWithUrl:UserRetrievePassword paramesers:dict requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];    } failure:^(NSError *error) {
            
        }];
}

+ (void)UserEditUserWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolPutWithUrl:User paramesers:parameser requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)UserEditUserPasswordWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolPutWithUrl:UserPassword paramesers:parameser requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)UserUploadIconWithParamesers:(NSDictionary *)parameser Icon:(UIImage *)img FileName:(NSString *)fileName Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolUploadWithUrl:UserUploadIcon paramesers:@{@"token":instance.token} requestHeaderField:@{@"token":instance.token}  Data:UIImagePNGRepresentation(img) Name:@"file" FileName:fileName MainType:@"image/gif" SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)UserFeedBackWithParamesers:(SkywareUserFeedBackModel *)model Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    model.app_version = [BundleTool getApp_Version];
    model.category = 1;
    model.app_id = [NSString stringWithFormat:@"%ld",instance.app_id];
    [SkywareHttpTool HttpToolPostWithUrl:UserFeedBack paramesers:model.keyValues requestHeaderField:@{@"token":instance.token}  SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

@end
