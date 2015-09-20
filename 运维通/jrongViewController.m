//
//  jrongViewController.m
//  运维通
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "jrongViewController.h"

@interface jrongViewController ()

@end

@implementation jrongViewController

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *kong=@"";
    [userDefaults setObject:kong forKey:@"personID"];
    [userDefaults setObject:kong forKey:@"personname"];

}


@end
