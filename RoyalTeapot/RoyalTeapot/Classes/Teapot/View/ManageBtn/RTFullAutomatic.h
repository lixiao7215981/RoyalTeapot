//
//  RTFullAutomatic.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTFullAutomatic : UIView

- (void) setManagerBtnState:(deviceStatus) status;
- (void) setManagerBtnState:(deviceStatus)status WithTimeout:(NSInteger) timeout;
@end
