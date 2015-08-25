//
//  RTTeapotHomeCenterBtnView.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/23.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "RTTeapotHomeCenterBtnView.h"
#import "RTFullAutomatic.h"
#import "RTManualHeatingView.h"
#import "RTManuallyAddWaterView.h"

#define managerBtnWH 70

@interface RTTeapotHomeCenterBtnView ()
{
    RTManuallyAddWaterView *_addWaterBtn;
    RTFullAutomatic *_autoBtn;
    RTManualHeatingView *_headBtn;
    deviceStatus _status;
    deviceStatus _addWaterStatus;
}
@end

@implementation RTTeapotHomeCenterBtnView

- (void)awakeFromNib
{
    //添加控制按钮
    [self addControlBtnVview];
}

/**
 *  请求接口得到数据
 *  HTTP
 */
- (void)setDeviceInfo:(SkywareDeviceInfoModel *)deviceInfo
{
    _deviceInfo = deviceInfo;
    DeviceStatusCodeModel *statusCode = [DeviceStatusCodeModel objectWithKeyValues:deviceInfo.device_data];
    if ([deviceInfo.device_online integerValue] == 1) { // 在线
        if ([statusCode.p boolValue]) { // 开机中
            NSInteger code = [[statusCode.m substringToIndex:1] integerValue];
            [_addWaterBtn setManagerBtnState:standby];
            [_autoBtn setManagerBtnState:standby];
            [_headBtn setManagerBtnState:standby];
            if (code == 0) { // 待机中
                _status = standby;
                
            }else if (code == 1){ // 全自动
                
                [_autoBtn setManagerBtnState:deviceStart WithTimeout:[self numerationTimeOutWithNowTime:[self.time integerValue] AndStartTime:[statusCode.t1 integerValue]]];
                
            }else if(code == 2){ // 手动煮水
                
                [_headBtn setManagerBtnState:deviceStart WithTimeout:[self numerationTimeOutWithNowTime:[self.time integerValue] AndStartTime:[statusCode.t2 integerValue]]];
            }
            if ([statusCode.f integerValue] == 0) { // 加水龙头静止
                _addWaterStatus = standby;
            }else if([statusCode.f integerValue] ==1){ // 加水
                
                [_addWaterBtn setManagerBtnState:deviceStart WithTimeout:[self numerationTimeOutWithNowTime:[self.time integerValue] AndStartTime:[statusCode.t3 integerValue]]];
                
            }else if([statusCode.f integerValue] == 2){
                
                [_addWaterBtn setManagerBtnState:standby];
            }
        }else{
            [_addWaterBtn setManagerBtnState:powerOff];
            [_autoBtn setManagerBtnState:powerOff];
            [_headBtn setManagerBtnState:powerOff];
        }
    }else{
        [_addWaterBtn setManagerBtnState:powerOff];
        [_autoBtn setManagerBtnState:powerOff];
        [_headBtn setManagerBtnState:powerOff];
    }
}

/**
 *  服务器推送
 *  MQTT
 */
- (void)setDataModel:(SkywareMQTTModel *)dataModel
{
    _dataModel = dataModel;
    RTMQTTResultDataModel *deviceCode = [RTMQTTResultDataModel objectWithKeyValues:dataModel.dataDictionary];
    if (dataModel.device_online) { // 在线
        if ([deviceCode.p boolValue]) { // 开机中
            NSInteger code = [[deviceCode.m substringToIndex:1] integerValue];
            if (code == 0) { // 待机中
                _status = standby;
                [_autoBtn setManagerBtnState:standby];
                [_headBtn setManagerBtnState:standby];
            }else if (code == 1){ // 全自动
                _status = deviceStart;
                [_autoBtn setManagerBtnState:deviceStart WithTimeout:0];
                [_headBtn setManagerBtnState:standby]; // 手动变为待机状态
            }else if(code == 2){ // 手动煮水
                _status = deviceStart;
                [_headBtn setManagerBtnState:deviceStart WithTimeout:0];
                [_autoBtn setManagerBtnState:standby]; // 自动变为待机状态
            }
        
            // 监控水龙头的状态
            if ([deviceCode.f integerValue] == 0) { // 加水龙头静止
                _addWaterStatus = standby;
                [_addWaterBtn setManagerBtnState:standby];
            }else if([deviceCode.f integerValue] == 1){ // 加水
                _addWaterStatus = deviceStart;
                [_addWaterBtn setManagerBtnState:deviceStart WithTimeout:0];
            }else if([deviceCode.f integerValue] == 2){
                _addWaterStatus = standby;
                [_addWaterBtn setManagerBtnState:standby];
            }
        }else{// 关机
            [self setControlBtnPower_offOrOn_line];
        }
    }else{
        [self setControlBtnPower_offOrOn_line];
    }
}

/**
 *  设置控制按钮关闭和离线状态下的状态
 */
- (void)setControlBtnPower_offOrOn_line
{
    [_addWaterBtn setManagerBtnState:powerOff];
    [_autoBtn setManagerBtnState:powerOff];
    [_headBtn setManagerBtnState:powerOff];
}

- (void)addControlBtnVview
{
    CGFloat space = 0;
    if (IS_IPHONE_5_OR_LESS) {
        space = 30;
    }else if (IS_IPHONE_6 || IS_IPHONE_6P){
        space = 40;
    }
    
    // Center 手动加水
    RTManuallyAddWaterView *waterView = [[NSBundle mainBundle] loadNibNamed:@"FullAutomaticManualBtn" owner:nil options:nil][1];
    waterView.translatesAutoresizingMaskIntoConstraints = NO;
    _addWaterBtn = waterView;
    [self addSubview:waterView];
    [waterView autoSetDimensionsToSize:CGSizeMake(managerBtnWH, managerBtnWH)];
    [waterView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [waterView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // left 全自动
    RTFullAutomatic *fullAutomatic = [[NSBundle mainBundle] loadNibNamed:@"FullAutomaticManualBtn" owner:nil options:nil][0];
    fullAutomatic.translatesAutoresizingMaskIntoConstraints = NO;
    _autoBtn = fullAutomatic;
    [self addSubview:fullAutomatic];
    [fullAutomatic autoSetDimensionsToSize:CGSizeMake(managerBtnWH, managerBtnWH)];
    [fullAutomatic autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [fullAutomatic autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:waterView withOffset:-space];
    
    // right 手动煮水
    RTManualHeatingView *heatingView =  [[NSBundle mainBundle] loadNibNamed:@"FullAutomaticManualBtn" owner:nil options:nil][2];
    heatingView.translatesAutoresizingMaskIntoConstraints = NO;
    _headBtn = heatingView;
    [self addSubview:heatingView];
    [heatingView autoSetDimensionsToSize:CGSizeMake(managerBtnWH, managerBtnWH)];
    [heatingView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [heatingView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:waterView withOffset:space];
}

/**
 *  计算时间
 */
- (NSInteger) numerationTimeOutWithNowTime:(NSInteger) nowTime AndStartTime:(NSInteger) startTime
{
    NSInteger time = nowTime - startTime;
    return time;
}

@end
