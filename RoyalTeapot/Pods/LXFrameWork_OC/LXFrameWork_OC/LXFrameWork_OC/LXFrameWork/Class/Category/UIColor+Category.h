//
//  UIColor+Category.h
//  rili365
//
//  Created by Li Xiang on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HexColor(colorStr) [UIColor colorWithHexString:colorStr]

@interface UIColor (UIColor_Category)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (NSArray *)someHexColors;

@end
