//
//  imgdetal.h
//  运维通
//
//  Created by abc on 15/8/30.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imgdetal : UIViewController
{
    UIScrollView *_scrollview;
}
@property(nonatomic,weak)NSString *strTtile;
@property(nonatomic,strong)NSString *receiveID;
@property(nonatomic,strong)NSString *receiveCbscs;
@end
