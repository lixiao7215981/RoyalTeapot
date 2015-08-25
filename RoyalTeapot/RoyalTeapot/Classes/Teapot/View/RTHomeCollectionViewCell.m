//
//  RTHomeCollectionViewCell.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "RTHomeCollectionViewCell.h"
#import "DeviceStatusCodeModel.h"

@interface RTHomeCollectionViewCell ()
/** 名字 */
@property (weak, nonatomic) IBOutlet UILabel *device_name;
/** 无设备/ 已关机 */
@property (weak, nonatomic) IBOutlet UILabel *device_state;
/** 状态的btn */
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
/** 摄氏度图标 */
@property (weak, nonatomic) IBOutlet UIImageView *t_img;

@end

@implementation RTHomeCollectionViewCell

- (void)awakeFromNib {
    
}

- (void)setDeviceInfo:(SkywareDeviceInfoModel *)deviceInfo
{
    _deviceInfo = deviceInfo;
    DeviceStatusCodeModel *statusCode = [DeviceStatusCodeModel objectWithKeyValues:deviceInfo.device_data];
    _device_name.text = deviceInfo.device_name;
    
    deviceStatus status = [deviceInfo.device_online integerValue] == 3 ? notDevice : offLine;
    if (status == notDevice) {
        [self setDeviceStyleWithStatus:status];
        return;
    }
    if ([deviceInfo.device_online boolValue]) {
        if ([statusCode.p boolValue]) { // 开机中
            NSInteger code = [[statusCode.m substringToIndex:1] integerValue];
            if (code == 0) { // 待机中
                status = standby;
            }else if (code == 1){ // 全自动
                status = autoMode;
            }else if(code == 2){ // 手动煮水
                status = manualModel;
            }
            if([statusCode.f integerValue] == 1){ // 加水
                status = addWater;
            }
            
            // 检测水温变化
            NSString *Tcode = [statusCode.t getTheCorrect] ;
            self.t.text = Tcode;
            if ([Tcode integerValue] == 100) {
                status = keepT; // 保温
            }
        }else{
            status = powerOff;// 关机
        }
    }
    [self setDeviceStyleWithStatus:status];
}

- (void)setDataModel:(SkywareMQTTModel *)dataModel
{
    _dataModel = dataModel;
    deviceStatus status = offLine;
    RTMQTTResultDataModel *deviceCode = [RTMQTTResultDataModel objectWithKeyValues:dataModel.dataDictionary];
    if (dataModel.device_online) { // 在线
        if ([deviceCode.p boolValue]) { // 开机中
            NSInteger code = [[deviceCode.m substringToIndex:1] integerValue];
            if (code == 0) { // 待机中
                status = standby;
            }else if (code == 1){ // 全自动
                status = autoMode;
            }else if(code == 2){ // 手动煮水
                status = manualModel;
            }
            if([deviceCode.f boolValue]){ // 加水
                status = addWater;
            }
            
            // 检测水温变化
            NSString *Tcode = [deviceCode.t getTheCorrect] ;
            self.t.text = Tcode;
            if ([Tcode integerValue] == 100) {
                status = keepT; // 保温
            }
        }
        else{
            status = powerOff;  // 关机
        }
    }
    [self setDeviceStyleWithStatus:status];
}

- (void)setDeviceStyleWithStatus:(deviceStatus)status
{
    if(status == notDevice){
        self.device_status.hidden = YES;
        self.t_img.hidden = YES;
        self.t.hidden = YES;
        self.device_state.hidden = NO;
        self.device_state.text = @"无设备";
        self.statusBtn.hidden = YES;
    }else if (status == offLine) {
        self.device_status.hidden = YES;
        self.t_img.hidden = YES;
        self.t.hidden = YES;
        self.device_state.hidden = NO;
        self.device_state.text = @"离线";
        self.statusBtn.hidden = YES;
    }else if (status == powerOff) {
        self.device_status.hidden = YES;
        self.t_img.hidden = YES;
        self.t.hidden = YES;
        self.device_state.hidden = NO;
        self.device_state.text = @"已关机";
        self.statusBtn.hidden = YES;
    }else if (status == standby){ // 待机
        self.device_status.hidden = NO;
        self.device_status.text = @"待机中";
        self.t_img.hidden = NO;
        self.t.hidden = NO;
        self.statusBtn.hidden = YES;
        self.device_state.hidden = YES;
    }else if(status == autoMode){ // 全自动
        self.device_status.hidden = NO;
        self.device_status.text = @"煮水中";
        self.t_img.hidden = NO;
        self.t.hidden = NO;
        self.device_state.hidden = YES;
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"自动" forState:UIControlStateNormal];
    }else if(status == manualModel){ // 手动煮水
        self.device_status.hidden = NO;
        self.device_status.text = @"煮水中";
        self.t_img.hidden = NO;
        self.t.hidden = NO;
        self.device_state.hidden = YES;
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"手动" forState:UIControlStateNormal];
    }else if(status == addWater){ // 加水
        self.device_status.hidden = NO;
        self.device_status.text = @"加水中";
        self.t_img.hidden = NO;
        self.t.hidden = NO;
        self.device_state.hidden = YES;
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"手动" forState:UIControlStateNormal];
    }else if(status == keepT){ // 保温中
        self.device_status.hidden = NO;
        self.device_status.text = @"保温中";
        self.t_img.hidden = NO;
        self.t.hidden = NO;
        self.device_state.hidden = YES;
        self.statusBtn.hidden = NO;
    }
}

@end
