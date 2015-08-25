//
//  BaseViewController.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IQKeyboardReturnKeyHandler.h>
#import <SVProgressHUD.h>
#import "NavigationBar.h"
#import "UIView+Extension.h"
#import "BlockButton.h"
#import "BundleTool.h"

#define kRGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kWindowWidth [UIScreen mainScreen].bounds.size.width

typedef void (^ClickButton)();

@interface BaseViewController : UIViewController

typedef UIView* (^ViewBlock)();

/***  NavBar的View */
@property (nonatomic,strong) NavigationBar *navView;


#pragma mark - Method

/**
 *  设置左边View
 */
- (void)setLeftView:(ViewBlock) leftViewBlock ;

/**
 *  设置右边View
 */
- (void)setRightView:(ViewBlock) rightViewBlock ;

/**
 *  设置中间View
 */
- (void)setCenterView:(ViewBlock) centerViewBlock ;

/**
 *  设置navigationBar 返回按钮
 */
- (UIButton *) setBackBtn;

/**
 *  设置 NavigationController Title
 */
- (UILabel *) setNavTitle:(NSString *) title;

/**
 *  设置leftBtn
 */
- (UIButton *) setLeftBtnWithImage:(UIImage *)image orTitle:(NSString *) title ClickOption:(ClickButton) clickOption ;

/**
 *  设置rightBtn
 */
- (UIButton *) setRightBtnWithImage:(UIImage *)image orTitle:(NSString *) title ClickOption:(ClickButton) clickOption ;



@end
