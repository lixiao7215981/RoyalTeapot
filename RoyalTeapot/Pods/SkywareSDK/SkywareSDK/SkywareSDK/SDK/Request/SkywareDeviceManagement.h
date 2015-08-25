//
//  SkywareDeviceManagement.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/20.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareHttpTool.h"

@interface SkywareDeviceManagement : NSObject

/**
 *  检测输入的 SN 码是否合法
 */
+ (void) DeviceVerifySN:(NSString *)sn Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  查询设备信息
 */
+ (void) DeviceQueryInfo:(SkywareDeviceQueryInfoModel *)queryModel Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  更新设备信息
 */
+ (void)DeviceUpdateDeviceInfo:(SkywareDeviceUpdateInfoModel *)updateModel Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  绑定设备（建立用户与设备的绑定关系）
 */
+ (void) DeviceBindUser:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  解除绑定（解除用户与设备的绑定关系）
 */
+ (void) DeviceReleaseUser:(NSArray *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  获取设备清单
 */
+ (void) DeviceGetAllDevicesSuccess:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  App 通过 http post 方式向设备发送指令，控制设备
 */
+ (void) DevicePushCMD:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  大循环中发送指令控制设备
 */
+ (void) DevicePushCMDWithData:(NSArray *)data;

@end
