//
//  UserCheckCodeView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserCheckCodeView.h"
#import "MessageCodeTool.h"
#import "TimeButton.h"

@interface UserCheckCodeView ()

/*** 验证码发送到手机提示 */
@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;
/*** 输入验证码 */
@property (weak, nonatomic) IBOutlet UITextField *authCode;
/*** 重新获取按钮 */
@property (weak, nonatomic) IBOutlet TimeButton *againBtn;
/*** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation UserCheckCodeView

- (void)awakeFromNib
{
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    self.againBtn.defineColor = UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor;
    [self.againBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    [self.checkBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    self.backgroundColor = UIM.User_view_bgColor == nil? UIM.All_view_bgColor :UIM.User_view_bgColor;
}

+ (instancetype)getUserCheckCodeView
{
    return [[NSBundle mainBundle]loadNibNamed:@"UserManager" owner:nil options:nil][1];
}

- (void)setParams:(NSDictionary *)params
{
    [super setParams:params];
    [self.againBtn startWithTimer:60];
    self.phoneTitle.text = [NSString stringWithFormat:@"激活码已发送到您%@的手机",self.params[@"phone"]];
}


- (IBAction)againBtnClick:(UIButton *)sender {
    [self.againBtn startWithTimer:60];
    [SVProgressHUD showWithStatus:@"获取验证码中..."];
    [MessageCodeTool getMessageCodeWithPhone:self.params[@"phone"] Zone:nil Success:^{
        [SVProgressHUD dismiss];
    } Error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取验证码失败，请稍后重试"];
    }];
}

- (IBAction)CheckCodeBtnClick:(UIButton *)sender {
    
    [self endEditing:YES];
    
    if(self.authCode.text.length!=4)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入4位验证码"];
        return;
    }else{
        [MessageCodeTool commitVerifyCode:self.authCode.text Success:^{
            if (self.option) {
                self.option();
            }
        } Error:^{
            [SVProgressHUD showErrorWithStatus:@"验证码有误,请重新输入"];
        }];
    }
}


@end
