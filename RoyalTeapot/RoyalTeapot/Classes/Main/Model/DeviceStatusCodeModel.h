//
//  DeviceStatusCodeModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/18.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

@interface DeviceStatusCodeModel : NSObject

/**  当前水温，单位℃   */
@property (nonatomic,copy) NSString *t ;
/**  开关   */
@property (nonatomic,copy) NSString *p ;
/**  加热状态 0：加热 1：未加热  */
@property (nonatomic,copy) NSString *h ;
/**  触发手动煮水时间戳  */
@property (nonatomic,copy) NSString *t2 ;
/**  模式  全自动/ 手动 */
@property (nonatomic,copy) NSString *m ;
/**  状态改变时间戳   */
@property (nonatomic,copy) NSString *ut ;
/**  故障   */
@property (nonatomic,copy) NSString *e ;
/**  触发手动加水时间戳   */
@property (nonatomic,copy) NSString *t3 ;
/**  水龙头状态  */
@property (nonatomic,copy) NSString *f ;
/**  触发全自动时间戳   */
@property (nonatomic,copy) NSString *t1 ;

@end
