//
//  ZoomScrollView.m
//  IphonePhotoAlbum
//
//  Created by lanou3g on 14-9-23.
//  Copyright (c) 2014年 zhouyongqing. All rights reserved.
//

#import "ZoomScrollView.h"

@interface ZoomScrollView ()




@end

@implementation ZoomScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame image:nil];
    if (self) {
        // Initialization code
//        [self setSubsView];
    }
    return self;
}

//- (void)setSubsView
//{
//    //获取ZoomScrollView的宽和高
//    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
//    
//    //创建滚动视图
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    _scrollView.backgroundColor = [UIColor grayColor];
//    [self addSubview:_scrollView];
//    [_scrollView release];
//    
//    //创建图像视图
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    _imageView.tag = 100;
//    _imageView.userInteractionEnabled = YES;
//    
//    [_scrollView addSubview:_imageView];
//    [_imageView release];
//    
//    //设置滚动视图的缩放范围
//    _scrollView.minimumZoomScale = 0.2;
//    _scrollView.maximumZoomScale = 10;
//    
//    _scrollView.delegate = self;
//    
////    //创建旋转手势
////    UIRotationGestureRecognizer * routationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
////    [_imageView addGestureRecognizer:routationGesture];
//}

//- (void)handleRotationGesture:(UIRotationGestureRecognizer *)gesture
//{
//        _imageView.transform = CGAffineTransformRotate(_imageView.transform, gesture.rotation);
//    NSLog(@"--%@",NSStringFromCGAffineTransform(_imageView.transform));
//        gesture.rotation = 0;
//}

-(void)setImage:(UIImage *)image
{
    _imageView.image = image;
}


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.image = image;
        _imageView.tag = 100;
        [self addSubview:_imageView];
        
        self.minimumZoomScale = 0.2;
        self.maximumZoomScale = 10;
        
        self.delegate = self;
    }
    return self;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1) {//当缩放比率小于1的时候,让imageView居中显示
        _imageView.center = CGPointMake(scrollView.bounds.size.width/2, scrollView.bounds.size.height/2);
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
 //   UIImageView *zoomView = (UIImageView *)[scrollView viewWithTag:100];
//    zoomView.center = _scrollView.center;
//    NSLog(@"!!!!!!!%@  %@", NSStringFromCGRect(zoomView.frame), NSStringFromCGRect(_scrollView.frame));
//    return zoomView;
    return _imageView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
