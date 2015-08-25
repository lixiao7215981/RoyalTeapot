//
//  DeviceSettingErrorView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceSettingErrorView.h"
#import <BaseDelegate.h>
#define Delegate  ((BaseDelegate *)[UIApplication sharedApplication].delegate)
@interface DeviceSettingErrorView ()

/**
 *  提示 textView
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/**
 *  重试按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
/**
 * 取消操作按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;

@end

@implementation DeviceSettingErrorView

- (void)awakeFromNib
{
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    self.backgroundColor = UIM.Device_view_bgColor == nil? UIM.All_view_bgColor :UIM.Device_view_bgColor;
    [self.againBtn setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    [self.cleanBtn setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    
    if (UIM.Device_setting_error.length) {
        self.textView.text = UIM.Device_setting_error;
    }else{
        NSString *text = @"很抱歉，无法顺利连接到设备，可能由于： \n1.请检查WiFi密码是否输入正确；\n2.当前环境内WiFi路由器过多；\n3.当前路由器禁用某些端口。\n\n我们建议：\n1.将设备断电重新上电，然后长按“手动加水”按键5～10秒，看到WiFi指示灯快闪，快速靠近再试一次；\n2.重启路由器或换一台手机试一下。";
        self.textView.text = text;
    }
    self.textView.font = [UIFont systemFontOfSize:17];
}

+ (instancetype)createDeviceSettingErrorView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AddDeviceViews" owner:nil options:nil][4];
}

- (IBAction)againBtnClick:(UIButton *)sender {
    if (self.option) {
        self.option();
    }
}

- (IBAction)cleanBtnClick:(UIButton *)sender {
    [Delegate.navigationController popToRootViewControllerAnimated:YES];
}


@end
