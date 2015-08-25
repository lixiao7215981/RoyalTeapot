//
//  SkywareSDK.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/4.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//


// 老接口地址：http://doc.skyware.com.cn/protocol/v1.3/S.html
// 新接口地址：https://github.com/nosun/skyiot/blob/master/protocol/standard/S.md


//#ifdef DEBUG

#define RTServersURL @"http://v1.skyware.com.cn/api"
#define kMQTTServerHost @"v1.skyware.com.cn"
//#define RT_token @"4pO-TCg"
//#else

//#define RTServersURL @"http://c2.skyware.com.cn/api"
//#define kMQTTServerHost @"m1.skyware.com.cn"
//#define RT_token @"GmF1lD"

//#endif

#ifdef DEBUG // 处于开发阶段
#define NSLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define NSLog(...)
#endif

/** MQTT 订阅设备MAC */
#define kTopic(deviceMac) [NSString stringWithFormat:@"sjw/%@",deviceMac]

/** 签名中 apiver(必填项) */
#define kSignature_apiver @"v1"

/** 签名中需要的key(必填项)  */
#define kSignature_key @"skyware"


#define kUserDataPath  [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:@"User.data"]

#import "SkywareDeviceUpdateInfoModel.h"
#import "SkywareDeviceQueryInfoModel.h"
#import "SkywareAddressWeatherModel.h"
#import "SkywareUserFeedBackModel.h"
#import "SkywareDeviceInfoModel.h"
#import "SkywareWeatherModel.h"
#import "SkywareUserInfoModel.h"
#import "SkywareInstanceModel.h"
#import "SkywareSendCmdModel.h"
#import "SkywareResult.h"
#import "SkywareMQTTModel.h"
#import "SkywareDeviceManagement.h"
#import "SkywareOthersManagement.h"
#import "SkywareUserManagement.h"
#import "SkywareConst.h"
#import "SkywareCloudURL.h"
#import "SkywareHttpTool.h"
#import "SkywareDeviceTool.h"
#import "SkywareMQTTTool.h"
#import "SkywareJSApiTool.h"





