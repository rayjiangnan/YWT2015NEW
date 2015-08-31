//
//  ShowViewController.m
//  IphonePhotoAlbum
//
//  Created by lanou3g on 14-9-25.
//  Copyright (c) 2014年 zhouyongqing. All rights reserved.
//

#import "ShowViewController.h"
#import "ZoomScrollView.h"
@interface ShowViewController ()
{
    UIScrollView * _buttomScrollView;
    UIPageControl * _pageControl;
    ZoomScrollView *_latestScrollView;
}
@end

@implementation ShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
//    
//    tap.numberOfTouchesRequired=2;
//    [self.view addGestureRecognizer:tap];
    
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(0, 40, 60, 20)];
    [but setTitle:@"返回" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:  but ];
    
    
    NSInteger lastImage = _idex;

    _buttomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-200)];
    _buttomScrollView.contentSize = CGSizeMake(_buttomScrollView.frame.size.width *( _receiveimageArray.count), _buttomScrollView.frame.size.height);
    [self.view addSubview:_buttomScrollView];
    _buttomScrollView.pagingEnabled = YES;
    _buttomScrollView.delegate = self;
   _buttomScrollView.contentOffset = CGPointMake((_idex-100) * _buttomScrollView.frame.size.width, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (int i = 0; i < _receiveimageArray.count; i++) {
        ZoomScrollView * scrollView = [[ZoomScrollView alloc] initWithFrame:CGRectMake(_buttomScrollView.frame.size.width * i, 0, _buttomScrollView.frame.size.width, _buttomScrollView.frame.size.height) image:_receiveimageArray[i]];
        
        [_buttomScrollView addSubview:scrollView];
        scrollView.tag = 100 + i;
    }

    //_latestScrollView = (ZoomScrollView *)[_buttomScrollView viewWithTag:lastImage];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(60,self.view.frame.size.height-84, 260, 30)];
    _pageControl.numberOfPages = _receiveimageArray.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    _pageControl.currentPage=_idex-100;
    [self.view addSubview:_pageControl];
    [_pageControl addTarget:self action:@selector(handlePageControlAction:) forControlEvents:(UIControlEventValueChanged)];
    
}
-(void)click
{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _buttomScrollView) {
        NSInteger number = scrollView.contentOffset.x / _buttomScrollView.frame.size.width;
        _pageControl.currentPage = number;
        self.navigationItem.title = [NSString stringWithFormat:@"第%ld张", number + 1];
//        _latestScrollView.zoomScale = 1.0;
//        _latestScrollView = (ZoomScrollView *)[_buttomScrollView viewWithTag:100 + number];
        NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        ZoomScrollView * leftScroll = (ZoomScrollView *)[_buttomScrollView viewWithTag:100 + currentPage - 1];
        ZoomScrollView * rightScroll = (ZoomScrollView *)[_buttomScrollView viewWithTag:100 + currentPage + 1];
        
        //还原缩放
        [leftScroll setZoomScale:1.0];
        [rightScroll setZoomScale:1.0];
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePageControlAction:(UIPageControl *)pageControl
{
    _buttomScrollView.contentOffset = CGPointMake(pageControl.currentPage * _buttomScrollView.frame.size.width, 0);
    self.navigationItem.title = [NSString stringWithFormat:@"第%ld张", pageControl.currentPage + 1];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
