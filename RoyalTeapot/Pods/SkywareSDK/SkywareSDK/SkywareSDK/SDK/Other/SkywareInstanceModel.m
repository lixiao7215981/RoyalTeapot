//
//  SkywareInstanceModel.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/23.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareInstanceModel.h"

@implementation SkywareInstanceModel

LXSingletonM(SkywareInstanceModel)

- (NSString *)token
{
    [[NSNotificationCenter defaultCenter ] postNotificationName:kNotUser_tokenGotoLogin object:nil];
    return _token;
}


- (void)PostApplicationDidBecomeActive
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidBecomeActive object:nil];
}

@end
