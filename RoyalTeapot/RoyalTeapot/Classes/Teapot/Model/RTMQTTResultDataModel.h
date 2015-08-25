//
//  RTMQTTResultDataModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/22.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTMQTTResultDataModel : NSObject

/***  水温 */
@property (nonatomic,copy) NSString *t;
/***  开关机状态 */
@property (nonatomic,copy) NSString *p;
/***  水龙头状态  */
@property (nonatomic,copy) NSString *f;
/***  故障 */
@property (nonatomic,copy) NSString *e;
/***  加热状态 */
@property (nonatomic,copy) NSString *h;
/***  模式 */
@property (nonatomic,copy) NSString *m;

@end
