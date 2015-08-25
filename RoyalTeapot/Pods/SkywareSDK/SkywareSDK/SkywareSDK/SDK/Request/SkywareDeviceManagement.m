//
//  SkywareDeviceManagement.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/20.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareDeviceManagement.h"
#import <objc/runtime.h>

@implementation SkywareDeviceManagement

+ (void)initialize
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    instance.sn = arc4random_uniform(65535) ;
    instance.cmd = @"download";
}

+ (void)DeviceVerifySN:(NSString *)sn Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSMutableArray *param = [NSMutableArray array];
    [param addObject:@(instance.app_id)];
    [param addObject:sn];
    [SkywareHttpTool HttpToolGetWithUrl:DeviceCheckSN paramesers:param requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)DeviceUpdateDeviceInfo:(SkywareDeviceUpdateInfoModel *)updateModel Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSString *url = [NSString stringWithFormat:@"%@/%@",DeviceUpdateInfo,updateModel.device_mac];
    NSLog(@"%@",updateModel.keyValues);
    [SkywareHttpTool HttpToolPutWithUrl:url paramesers:updateModel.keyValues requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)DeviceQueryInfo:(SkywareDeviceQueryInfoModel *)queryModel Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    NSMutableArray *parameser = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([SkywareDeviceQueryInfoModel class], &count);
    for (int i= 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        id propertyVal =  [queryModel valueForKeyPath:[NSString stringWithUTF8String:name]];
        if (propertyVal) {
            [parameser addObject:[NSString stringWithFormat:@"%@/%@",[[NSString stringWithUTF8String:name] substringFromIndex:1] ,propertyVal]];
            continue;
        }
    }
    if (!parameser.count) return;
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolGetWithUrl:DeviceQueryInfo paramesers: parameser requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
    
}

+ (void)DeviceBindUser:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolPostWithUrl:DeviceBindUser paramesers:parameser requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)DeviceReleaseUser:(NSArray *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolDeleteWithUrl:DeviceReleaseUser paramesers:parameser requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)DeviceGetAllDevicesSuccess:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolGetWithUrl:DeviceGetAllDevices paramesers:nil requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)DevicePushCMD:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    [SkywareHttpTool HttpToolPostWithUrl:DevicePushCMD paramesers:parameser requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  发送指令
 */
+(void)DevicePushCMDWithData:(NSArray *)data
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!instance) return;
    [params setObject: instance.device_id forKey:@"device_id"];
    [params setObject:[SkywareDeviceManagement controlCommandvWithArray:data] forKey:@"commandv"];
    [SkywareDeviceManagement DevicePushCMD:params Success:^(SkywareResult *result) {
        NSLog(@"指令发送成功---%@",params);
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        NSLog(@"指令发送失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 *  拼接指令串
 */
+(NSMutableString *)controlCommandvWithArray:(NSArray *)data
{
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    NSMutableString  *commandv ;
    commandv= [NSMutableString stringWithString:@"{\"sn\":"];
    [commandv appendFormat: @"%ld",instance.sn];
    [commandv appendFormat:@",\"cmd\":\"%@\",\"data\":[",instance.cmd];
    for (int i = 0; i<data.count; i++) {
        [commandv appendFormat:@"\"%@\"",data[i]];
        if (i != data.count - 1) {
            [commandv appendString:@","];
        }
    }
    [commandv appendString:@"]}\n"];
    return commandv;
}

@end
