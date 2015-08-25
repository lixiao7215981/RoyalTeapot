//
//  NSDate+Extension.h
//  LiXiao
//
//  Created by 李晓 on 14-10-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *  判断是不是今年
 */
- (BOOL) isThisYear;
/**
 *  判断是不是今天
 */
- (BOOL) isToday;

/**
 *  判断是不是昨天
 */
-(BOOL) isYesterday;

/**
 *  将NSDate转换为 YYYY-MM-DD  HH:mm:ss
 */
- (NSString*)FormatterYMDHMS;

@end
