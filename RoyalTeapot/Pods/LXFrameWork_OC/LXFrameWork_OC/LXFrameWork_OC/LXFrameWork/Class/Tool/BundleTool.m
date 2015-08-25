//
//  BundleTool.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/10.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BundleTool.h"

#define BUNDLE_PATH(name) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: (name)]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@implementation BundleTool


+ (UIImage *)getImage:(NSString *)img FromBundle:(NSString *)bundle
{
    UIImage *image=[UIImage imageWithContentsOfFile:[BUNDLE_PATH(bundle) stringByAppendingPathComponent : img]];
    return image;
}

+ (id)getViewControllerNibName:(NSString *)name FromBundle:(NSString *)bundle
{
    Class vc = NSClassFromString(name);
    return [[vc alloc] initWithNibName:name bundle:[NSBundle bundleWithPath: BUNDLE_PATH(bundle)]];
}

+ (NSString *)getApp_Version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

@end
