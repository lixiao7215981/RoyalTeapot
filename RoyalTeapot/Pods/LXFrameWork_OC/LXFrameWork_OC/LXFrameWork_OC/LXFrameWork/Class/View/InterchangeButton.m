//
//  InterchangeButton.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/14.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "InterchangeButton.h"

@implementation InterchangeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 8;
    CGFloat titleY = 0;
    CGFloat titleW = 0;
    CGFloat titleH = contentRect.size.height;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    titleW = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.width;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageX = self.bounds.size.width - imageW + 8;
    CGFloat imageY = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
    
}

@end
