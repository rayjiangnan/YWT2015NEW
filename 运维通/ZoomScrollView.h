//
//  ZoomScrollView.h
//  IphonePhotoAlbum
//
//  Created by lanou3g on 14-9-23.
//  Copyright (c) 2014年 zhouyongqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomScrollView : UIScrollView<UIScrollViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
@end
