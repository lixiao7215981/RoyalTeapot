//
//  RTMenuViewController.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "RTMenuViewController.h"
#import "TestWebViewController.h"
#import <AddDeviceViewController.h>
#import <UserAccountViewController.h>
#import <DeviceManagerViewController.h>
#import <SystemFeedBackViewController.h>
#import <SystemAboutViewController.h>
#import <SkywareUIConst.h>
@interface RTMenuViewController ()

@end

@implementation RTMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"菜单"];
    [self getUserInfo];
    [kNotificationCenter addObserver:self selector:@selector(getUserInfo) name:kEditUserNickNameRefreshTableView object:nil];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

- (void) getUserInfo
{
    [SkywareUserManagement UserGetUserWithParamesers:nil Success:^(SkywareResult *result) {
        SkywareUserInfoModel *userInfo = [SkywareUserInfoModel objectWithKeyValues:[result.result firstObject]];
        [SVProgressHUD dismiss];
        [self setUpDataListWith:userInfo];
    } failure:^(SkywareResult *result) {
        
    }];
}

- (void)setUpDataListWith:(SkywareUserInfoModel *) user
{
    BaseIconItem *iconItem ;
    
    NSString *user_icon = (user.user_img.length == 0 || user == nil )? @"view_userface" :user.user_img;
    NSString *user_name = (user.user_name.length == 0 || user == nil )? @"匿名" : user.user_name;
    NSString *user_phone = (user.user_phone.length == 0 || user == nil )? @"" :user.user_phone;
    
    iconItem = [BaseIconItem createBaseCellItemWithIconNameOrUrl:user_icon AndTitle:user_name SubTitle:user_phone ClickCellOption:^{
        UserAccountViewController *account = [[UserAccountViewController alloc] init];
        account.user_name = user_name;
        account.user_img = user_icon;
        [self.navigationController pushViewController:account animated:YES];
    } ClickIconOption:nil];
    
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadView:iconItem.sectionView AndFootView:iconItem.sectionView OrItem:@[iconItem]];
    
    BaseArrowCellItem *buyItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_buy" AndTitle:@"一键购买" SubTitle:nil ClickOption:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rsdcw.jd.com/"]];
    }];
    
    BaseArrowCellItem *deviceManagerItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_device" AndTitle:@"设备管理" SubTitle:nil ClickOption:^{
        DeviceManagerViewController *deviceManager = [[DeviceManagerViewController alloc] init];
        [self.navigationController pushViewController:deviceManager animated:YES];
    }];
    
    BaseArrowCellItem *timeItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_timer" AndTitle:@"定时管理" SubTitle:nil ClickOption:^{
        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
    }];
    
    BaseArrowCellItem *addDeviceItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_scan" AndTitle:@"添加设备" SubTitle:nil ClickOption:^{
        // 添加设备操作
        AddDeviceViewController *deviceVC = [[AddDeviceViewController alloc] init];
        [self.navigationController pushViewController:deviceVC animated:YES];
    }];
    
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithItem:@[buyItem,deviceManagerItem,timeItem,addDeviceItem]];
    
    BaseArrowCellItem *helpItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_help" AndTitle:@"帮助" SubTitle:nil ClickOption:^{
        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
        
        //   测试天气接口
        //        SkywareWeatherModel *model = [[SkywareWeatherModel alloc] init];
        //        model.province = @"河北省";
        //        model.city = @"沧州市";
        //        model.district = @"吴桥县";
        //        [SkywareOthersManagement UserAddressWeatherParamesers:model Success:^(SkywareResult *result) {
        //            SkywareAddressWeatherModel *addressModel = [SkywareAddressWeatherModel objectWithKeyValues:result.result];
        //            NSLog(@"%@",addressModel);
        //        } failure:^(SkywareResult *result) {
        //            NSLog(@"%@",result);
        //        }];
        
    }];
    
    BaseArrowCellItem *feedbackItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_feedback" AndTitle:@"反馈" SubTitle:nil ClickOption:^{
        SystemFeedBackViewController *feedBack = [[SystemFeedBackViewController alloc] initWithNibName:@"SystemFeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:feedBack animated:YES];
    }];
    
    BaseArrowCellItem *aboutItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_about" AndTitle:@"关于" SubTitle:nil ClickOption:^{
        SystemAboutViewController *about = [[SystemAboutViewController alloc] initWithNibName:@"SystemAboutViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
    }];
    
    BaseCenterTitleCellItem *centerTitle = [BaseCenterTitleCellItem createBaseCellItemWithCenterTitle:@"退出登录" ClickOption:^{
        [[[UIAlertView alloc] initWithTitle:@"您确定要注销吗？" message:@"注销后会跳转到登录页面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    } WithColor: [UIColor redColor]];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 25)];
    sectionLabel.text = @"您可以通过扫描或输入机身编码绑定新的设备";
    sectionLabel.textColor = [UIColor grayColor];
    sectionLabel.font = [UIFont systemFontOfSize:14];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.backgroundColor = kRGBColor(231, 231, 231, 1);
    
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithHeadView:sectionLabel AndFootView:nil OrItem:@[helpItem,feedbackItem,aboutItem,centerTitle]];
    
    [self.dataList removeAllObjects];
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
    [self.dataList addObject:group3];
    
    
    // 测试Web形势控制
    
    //    BaseArrowCellItem *cell = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"Web形式控制" SubTitle:nil ClickOption:^{
    //        TestWebViewController *web = [[TestWebViewController alloc] init];
    //
    //        [self.navigationController pushViewController:web animated:YES];
    //    } AndDetailClass:nil];
    //    BaseCellItemGroup *group4 = [BaseCellItemGroup createGroupWithHeadTitle:@"测试功能" AndFooterTitle:nil OrItem:@[cell]];
    //    [self.dataList addObject:group4];
    
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 清除保存的用户名密码
        [NSKeyedArchiver archiveRootObject:[[SkywareResult alloc] init] toFile:[PathTool getUserDataPath]];
        // 清除用户detoken
        SkywareInstanceModel * instance = [SkywareInstanceModel sharedSkywareInstanceModel];
        instance.token = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 调回到登陆界面
            UserLoginViewController *loginRegister = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
            [UIWindow changeWindowRootViewController:loginRegister];
            
        });
    }
}

@end
