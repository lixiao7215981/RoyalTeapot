//
//  PathTool.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/24.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "PathTool.h"

@implementation PathTool

+ (NSString *)getUserDataPath
{
    return [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:@"User.data"];
}

@end
