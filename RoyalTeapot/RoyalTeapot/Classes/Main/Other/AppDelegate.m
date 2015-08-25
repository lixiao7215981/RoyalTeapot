//
//  AppDelegate.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/9.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK.h>
#import <PgySDK/PgyManager.h>
#import "RTTeapotHomeViewController.h"
#import <UserLoginViewController.h>
#import <SkywareUIInstance.h>
#import <LXFrameWorkInstance.h>

#define SMS_SDKAppKey    @"888af4137d99"
#define SMS_SDKAppSecret  @"907cae6bb1ecc40c41182c0109b61a21"
#define PGY_SDKAppKey  @"4651c78ca4d87f651a8c795d7ed27ba4"

@interface AppDelegate ()
{
    SkywareInstanceModel * _skywareInstance;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UserLoginViewController *loginRegister = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
    self.window.rootViewController = loginRegister;
    
    self.navigationController = (UINavigationController *)loginRegister;
    [self.window makeKeyAndVisible];
    
    // 设置 App_id
    _skywareInstance = [SkywareInstanceModel sharedSkywareInstanceModel];
    _skywareInstance.app_id = 5;
    
    // 设置弹出框后不可操作
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:kRGBColor(230, 230, 230, 1)];
    
    // 启动ShareSDK 的短信功能
    [SMS_SDK registerApp:SMS_SDKAppKey withSecret:SMS_SDKAppSecret];
    [SMS_SDK enableAppContactFriends:NO];
    
    
    // 开启网络监听
    [BaseNetworkTool startNetWrokWithURL:@"v1.skyware.com.cn"];
    
    // 设置系统样式
    [self settingSystemStyle];
    
    //关闭用户反馈功能
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    // 蒲公英启动
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_SDKAppKey];
    // 检查更新
    [[PgyManager sharedPgyManager] checkUpdate];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 从后台进入到前台，发送通知
    [_skywareInstance PostApplicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Method

- (void) settingSystemStyle
{
//    LXFrameWorkInstance *instance = [LXFrameWorkInstance sharedLXFrameWorkInstance];
//    instance.NavigationBar_bgColor = [UIColor lightGrayColor];
    
    SkywareUIInstance *UIinstance = [SkywareUIInstance sharedSkywareUIInstance];
    UIinstance.All_button_bgColor = kSystemRedBtnColor;
    UIinstance.User_view_bgColor = kSystemLoginViewBackageColor;
    UIinstance.User_loginView_logo = [UIImage imageNamed:@"login_logo"];
}

@end
