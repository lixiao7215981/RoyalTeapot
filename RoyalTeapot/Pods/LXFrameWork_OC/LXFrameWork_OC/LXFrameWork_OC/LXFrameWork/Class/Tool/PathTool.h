//
//  PathTool.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/24.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Extension.h"

@interface PathTool : NSObject

/**
 *  获取用户基本信息保存路径
 *
 *  @return 路径
 */
+ (NSString *) getUserDataPath;

@end
