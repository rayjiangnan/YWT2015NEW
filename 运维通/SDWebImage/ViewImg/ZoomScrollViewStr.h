//
//  ZoomScrollViewStr.h
//  运维通
//
//  Created by ritacc on 15/10/7.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomScrollViewStr : UIScrollView<UIScrollViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
@end
