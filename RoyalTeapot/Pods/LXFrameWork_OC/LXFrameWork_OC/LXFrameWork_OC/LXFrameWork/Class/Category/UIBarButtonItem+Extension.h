//
//  UIBarButtonItem+Extension.h
//  HM新浪微博
//
//  Created by 李晓 on 14-10-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *) itemWitchTaget:(id)target action:(SEL) action Image:(NSString *) image highlightImage:(NSString *) hightImage;

@end
