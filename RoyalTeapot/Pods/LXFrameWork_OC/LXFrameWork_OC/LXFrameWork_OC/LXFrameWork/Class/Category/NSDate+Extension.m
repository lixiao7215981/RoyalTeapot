//
//  NSDate+Extension.m
//  LiXiao
//
//  Created by 李晓 on 14-10-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  判断是不是今年
 *
 */
- (BOOL) isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger crateYear =  [calendar components: NSCalendarUnitYear fromDate:self].year;
    NSInteger nowYear = [calendar components: NSCalendarUnitYear fromDate:[NSDate date]].year;
    return crateYear == nowYear;
}

/**
 *  判断是不是今天
 *
 */
- (BOOL) isToday
{
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    sdf.dateFormat = @"yyyy-MM-dd";
    NSString *createStr = [sdf stringFromDate:self];
    NSString *nowStr = [sdf stringFromDate:[NSDate date]];
    return [createStr isEqualToString:nowStr];
}

/**
 *  判断是不是昨天
 *
 */
-(BOOL) isYesterday
{
    NSCalendarUnit unit = kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    sdf.dateFormat = @"yyyy-MM-dd";
    NSString *createStr = [sdf stringFromDate:self];
    NSDate *createDate = [sdf dateFromString:createStr];
    
    NSString *nowStr = [sdf stringFromDate:[NSDate date]];
    NSDate *nowDate = [sdf dateFromString:nowStr];
    
    NSDateComponents *component =  [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    return (component.year ==0 && component.month == 0 && component.day == 1);
}

- (NSString*)FormatterYMDHMS
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:self];
}

@end
