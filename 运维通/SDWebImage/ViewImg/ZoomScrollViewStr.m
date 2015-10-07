//
//  ZoomScrollViewStr.m
//  运维通
//
//  Created by ritacc on 15/10/7.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "ZoomScrollViewStr.h"
#import "UIImageView+WebCache.h"


@interface ZoomScrollViewStr ()

@end

@implementation ZoomScrollViewStr

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame image:nil];
    if (self) {
        // Initialization code
        //        [self setSubsView];
    }
    return self;
}



-(void)setImage:(UIImage *)image
{
    _imageView.image = image;
}


- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)strimage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
         NSURL *imgurl=[NSURL URLWithString:strimage];
        
        [_imageView setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:strimage]];
 
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
