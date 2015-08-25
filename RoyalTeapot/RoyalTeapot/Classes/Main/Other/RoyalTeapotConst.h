//
//  RoyalTeapotConst.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/21.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoyalTeapotConst : NSObject

/** 手动煮水发送通知，结束全自动模式 */
extern NSString * const kManualHeatingStartEndAuto;

/** 全自动模式发送通知，结束手动煮水模式 */
extern NSString * const kFullAutoStartEndHeating;

/** 滚动首页茶壶页面，删除加水提醒框 */
extern NSString * const kScrollHomeViewRemoveLabel;


@end
