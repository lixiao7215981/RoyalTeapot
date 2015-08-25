//
//  UserLoginViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserLoginViewController.h"

@interface UserLoginViewController ()
/*** 登录名 */
@property (weak, nonatomic) IBOutlet UITextField *phone;
/*** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *password;
/*** 登录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/*** 登录页面Logo */
@property (weak, nonatomic) IBOutlet UIImageView *loginLogo;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.hidden = YES;
    
    // 设置页面元素
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    [_loginBtn setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor : UIM.User_button_bgColor];
    _loginLogo.image = UIM.User_loginView_logo;
    self.view.backgroundColor = UIM.User_view_bgColor == nil? UIM.All_view_bgColor :UIM.User_view_bgColor;
    
    // 页面加载完成后清空输入框
    self.phone.text = @"";
    self.password.text = @"";
    
    // 自动登录
    SkywareResult *result = [NSKeyedUnarchiver unarchiveObjectWithFile:[PathTool getUserDataPath]];
    if (result.phone.length && result.password.length) { // 保存有用户名密码，跳转到首页
        [SVProgressHUD showWithStatus:@"自动登录中..."];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:result.phone forKey:@"login_id"];
        [param setObject:result.password forKey:@"login_pwd"];
        [SkywareUserManagement UserLoginWithParamesers:param Success:^(SkywareResult *result) {
            // 将用户token 保存到单例中
            SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
            instance.token = result.token;
            [SVProgressHUD dismiss];
            [UIWindow changeWindowRootViewController:[[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController]];
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"自动登录失败,请重新输入用户名密码"];
        }];
    }
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    if (!self.phone.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (!self.password.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.phone.text forKey:@"login_id"];
    [param setObject:self.password.text forKey:@"login_pwd"];
    [SkywareUserManagement UserLoginWithParamesers:param Success:^(SkywareResult *result) {
        // 将用户信息保存到本地
        result.phone = self.phone.text;
        result.password = self.password.text;
        [NSKeyedArchiver archiveRootObject:result toFile:[PathTool getUserDataPath]];
        
        // 将用户token 保存到单例中
        SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
        instance.token = result.token;
        
        [SVProgressHUD dismiss];
        [UIWindow changeWindowRootViewController:[[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController]];
    } failure:^(SkywareResult *result) {
        if ([result.message isEqualToString:@"404"]) {
            [SVProgressHUD showErrorWithStatus:@"您还没有注册，请先注册"];
            return ;
        }
        [SVProgressHUD showErrorWithStatus:@"用户名密码或密码错误"];
    }];
}

@end
