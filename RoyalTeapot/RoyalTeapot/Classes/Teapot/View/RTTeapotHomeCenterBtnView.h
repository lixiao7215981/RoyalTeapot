//
//  RTTeapotHomeCenterBtnView.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/23.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTMQTTResultDataModel.h"

@interface RTTeapotHomeCenterBtnView : UIView

/**
 *  请求返回的数据
 */
@property (nonatomic,strong) SkywareDeviceInfoModel *deviceInfo;
/**
 *  MQTT 推送过来的数据
 */
@property (nonatomic,strong) SkywareMQTTModel *dataModel;
/**
 *  服务器时间，用来计算按钮倒计时时间
 */
@property (nonatomic,copy) NSString *time;

@end
