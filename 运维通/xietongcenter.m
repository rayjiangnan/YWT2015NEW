//
//  xietongcenter.m
//  运维通
//
//  Created by abc on 15/8/8.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "xietongcenter.h"
#import "UIViewController+Extension.h"

@interface xietongcenter ()

@end

@implementation xietongcenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *myColorRGB =[self GetUIColor];
    
    
    
    self.navigationController.navigationBar.barTintColor=myColorRGB;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=NO;
}



@end
