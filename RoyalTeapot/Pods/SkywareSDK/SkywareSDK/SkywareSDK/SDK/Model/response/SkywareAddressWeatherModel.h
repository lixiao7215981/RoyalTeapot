//
//  SkywareAddressWeatherModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareAddressWeatherModel : NSObject

/**
 *  温度
 */
@property (nonatomic,copy) NSString *temperature;
/**
 *  湿度
 */
@property (nonatomic,copy) NSString *humidity;
/**
 *  PM 值
 */
@property (nonatomic,copy) NSString *pm;
/**
 *  空气质量指数
 */
@property (nonatomic,copy) NSString *aqi;

@end
