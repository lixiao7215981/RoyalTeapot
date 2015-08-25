//
//  SkywareInstanceModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/23.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LXSingleton.h>
#import "SkywareConst.h"

@interface SkywareInstanceModel : NSObject

@property (nonatomic,assign) NSInteger app_id;

@property (nonatomic,assign) NSInteger sn;

@property (nonatomic,copy) NSString *cmd;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *device_id;

LXSingletonH(SkywareInstanceModel)

/**
 *  从后台进入到前台，发送通知
 */
- (void) PostApplicationDidBecomeActive;

@end
