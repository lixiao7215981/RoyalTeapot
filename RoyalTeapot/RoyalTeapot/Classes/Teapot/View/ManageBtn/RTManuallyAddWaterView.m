//
//  RTManuallyAddWaterView.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//


#import "RTManuallyAddWaterView.h"

@interface RTManuallyAddWaterView ()
{
    deviceStatus _status;
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *timeImg;
@property (nonatomic,strong) UILabel *alertLabel;

@end

@implementation RTManuallyAddWaterView

- (void)awakeFromNib
{
    [self setManagerBtnState:standby];
    [kNotificationCenter addObserver:self selector:@selector(labelRemove) name:kScrollHomeViewRemoveLabel object:nil];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

- (void)setManagerBtnState:(deviceStatus)status WithTimeout:(NSInteger) timeout
{
    if(_status == status) return;
    _status = status;
    [self setManagerBtnState:status];
    [self startWithTimer:(30 - timeout)];
    [self addAlertLabel];
}


- (void)setManagerBtnState:(deviceStatus)status
{
    _status = status;
    if (status == powerOff) { // 关闭/离线
        [self endTimed];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_manual_add_gray"] forState:UIControlStateNormal];
        [self.backBtn setTitle:@"" forState:UIControlStateNormal];
        self.timeImg.hidden = YES;
    }else if (status == standby){  // 待机
        [self endTimed];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_manual_add_normal"] forState:UIControlStateNormal];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_manual_add_pressed"] forState:UIControlStateHighlighted];
        [self.backBtn setTitle:@"" forState:UIControlStateNormal];
        self.timeImg.hidden = YES;
    }else if (status == deviceStart){ // 开始执行
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_manual_add_timer_normal"] forState:UIControlStateNormal];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_manual_add_timer_pressed"] forState:UIControlStateHighlighted];
        self.timeImg.hidden = NO;
    }
}

- (void) endTimed
{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (IBAction)manualBtnClick:(UIButton *)sender {
    if (_status == standby) { // 开机
        [SkywareDeviceManagement DevicePushCMDWithData:@[@"m::30000"]];
    }else if (_status == deviceStart){ // 待机
        [SkywareDeviceManagement DevicePushCMDWithData:@[@"m::30000"]];
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
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%lds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.backBtn setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (void) addAlertLabel
{
    if (_alertLabel) return;
    _alertLabel= [UILabel newAutoLayoutView];
    _alertLabel.layer.cornerRadius = 3;
    _alertLabel.clipsToBounds = YES;
    _alertLabel.font = [UIFont systemFontOfSize:15];
    _alertLabel.text = @"注意: 请注意水满溢出!";
    _alertLabel.textColor = [UIColor whiteColor];
    _alertLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_alertLabel];
    [_alertLabel autoSetDimensionsToSize:CGSizeMake(200, 20)];
    [_alertLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_alertLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-40];
    
    [self performSelector:@selector(labelRemove) withObject:nil afterDelay:5.0f];
}

- (void) labelRemove
{
    [_alertLabel removeFromSuperview];
    _alertLabel = nil;
}

@end
