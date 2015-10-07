//
//  guanli.m
//  运维通
//
//  Created by abc on 15/8/8.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "guanli.h"

@interface guanli ()
@property (weak, nonatomic) IBOutlet UIView *vRengzhenAudit;

@end

@implementation guanli

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *myColorRGB =[self GetUIColor];

    self.navigationController.navigationBar.barTintColor=myColorRGB;

    [self.navigationController.navigationBar setTitleTextAttributes:

    @{NSFontAttributeName:[UIFont systemFontOfSize:17],

    NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL SuppAdmin= [userDefaultes boolForKey:@"SuppAdmin"];
    
    if (SuppAdmin) {
        self.vRengzhenAudit.hidden=NO;
    }
    else
    {
        self.vRengzhenAudit.hidden=TRUE;
    }
}

-(void)viewDidAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden=NO;
}

@end
