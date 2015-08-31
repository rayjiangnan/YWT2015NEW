//
//  ShowViewController.h
//  IphonePhotoAlbum
//
//  Created by lanou3g on 14-9-25.
//  Copyright (c) 2014年 zhouyongqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger idex;
@property (nonatomic,strong)NSMutableArray *receiveimageArray;

@end
