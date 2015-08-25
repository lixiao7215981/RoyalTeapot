//
//  RTFullAutomatic.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "RTFullAutomatic.h"

@interface RTFullAutomatic ()
{
    deviceStatus _status;
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *timeImg;

@end

@implementation RTFullAutomatic

- (void)awakeFromNib
{
    [self setManagerBtnState:standby];
    [kNotificationCenter addObserver:self selector:@selector(endManualHeating) name:kManualHeatingStartEndAuto object:nil];
}

- (void)endManualHeating
{
    [self setManagerBtnState:standby];
}

- (void)setManagerBtnState:(deviceStatus)status WithTimeout:(NSInteger) timeout
{
    if(_status == status) return;
    _status = status;
    [self setManagerBtnState:status];
    [self startWithTimer:(1200 - timeout)];
}

- (void) setManagerBtnState:(deviceStatus) status;
{
    _status = status;
    if (status == powerOff) {
        [self endTimed];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_auto_gray"] forState:UIControlStateNormal];
        [self.backBtn setTitle:@"" forState:UIControlStateNormal];
        self.timeImg.hidden = YES;
    }else if (status == standby){
        [self endTimed];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_auto_normal"] forState:UIControlStateNormal];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_auto_pressed"] forState:UIControlStateHighlighted];
        [self.backBtn setTitle:@"" forState:UIControlStateNormal];
        self.timeImg.hidden = YES;
    }else if (status == deviceStart){
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_auto_timer_normal"] forState:UIControlStateNormal];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_auto_timer_pressed"] forState:UIControlStateHighlighted];
        self.timeImg.hidden = NO;
    }
}

- (void) endTimed
{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (IBAction)autoBtnClick:(UIButton *)sender {
    if (_status == standby) { // 开机
        [SkywareDeviceManagement DevicePushCMDWithData:@[@"m::10100"]];
        //全自动模式发送通知，结束手动煮水模式
        [kNotificationCenter postNotificationName:kFullAutoStartEndHeating object:nil];
    }else if (_status == deviceStart){ // 待机
        [SkywareDeviceManagement DevicePushCMDWithData:@[@"m::10100"]];
        [self endTimed];
    }
}

- (void)startWithTimer:(NSInteger)time
{
    __block NSInteger timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setManagerBtnState:standby];
            });
        }else{
            NSInteger minutes = timeout / 60;
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%ld:%.2ld",minutes, seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.backBtn setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

@end
