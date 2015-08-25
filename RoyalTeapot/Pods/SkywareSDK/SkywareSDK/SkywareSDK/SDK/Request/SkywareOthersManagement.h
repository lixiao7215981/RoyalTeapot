//
//  SkywareOthersManagement.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareHttpTool.h"

@interface SkywareOthersManagement : NSObject

/**
 *  天气接口
 */
+ (void) UserAddressWeatherParamesers:(SkywareWeatherModel *) model Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

@end
