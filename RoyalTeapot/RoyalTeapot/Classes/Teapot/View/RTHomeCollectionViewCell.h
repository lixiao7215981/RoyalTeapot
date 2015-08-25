//
//  RTHomeCollectionViewCell.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkywareDeviceInfoModel.h"
#import "RTMQTTResultDataModel.h"

@interface RTHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) SkywareDeviceInfoModel *deviceInfo;

@property (nonatomic,strong) SkywareMQTTModel *dataModel;

/** 待机中 */
@property (weak, nonatomic) IBOutlet UILabel *device_status;
/** 水温 */
@property (weak, nonatomic) IBOutlet UILabel *t;

/**
 *  设置首页CollectionViewCell 的茶壶状态
 */
- (void)setDeviceStyleWithStatus:(deviceStatus)status;

@end
