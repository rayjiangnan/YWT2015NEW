//
//  sywindex.m
//  运维通
//
//  Created by abc on 15/8/10.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "sywindex.h"
#import"MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"

@interface sywindex ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *realname;
@property (weak, nonatomic) IBOutlet UIButton *renz;
@property (weak, nonatomic) IBOutlet UILabel *wdyd;
@property (weak, nonatomic) IBOutlet UILabel *wcyd;
@property (weak, nonatomic) IBOutlet UILabel *dwcyd;
@property (weak, nonatomic) IBOutlet UIImageView *x5;
@property (weak, nonatomic) IBOutlet UIImageView *x4;
@property (weak, nonatomic) IBOutlet UIImageView *x3;
@property (weak, nonatomic) IBOutlet UIImageView *x2;
@property (weak, nonatomic) IBOutlet UIImageView *x1;


@end

@implementation sywindex

-(void)viewDidAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=YES;
    self.tabBarController.tabBar.hidden=YES;
    
    [self ChangePageInit:@"Order"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIColor *myColorRGB =[self GetUIColor];
    
    
    
    self.navigationController.navigationBar.barTintColor=myColorRGB;

    [self.navigationController.navigationBar setTitleTextAttributes:

    @{NSFontAttributeName:[UIFont systemFontOfSize:17],

    NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    [self network];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Certify = [userDefaultes stringForKey:@"Certify"];
    NSString *star = [userDefaultes stringForKey:@"star"];
    NSString *RealName = [userDefaultes stringForKey:@"RealName"];
    NSString *UserImg = [userDefaultes stringForKey:@"UserImg"];
    
    self.realname.text=RealName;
    if ([Certify isEqualToString:@"0"]) {
        [self.renz setTitle:@"未认证" forState:UIControlStateNormal];
    }else if ([Certify isEqualToString:@"1"]) {
        [self.renz setTitle:@"已认证" forState:UIControlStateNormal];
    }else if ([Certify isEqualToString:@"2"]) {
        [self.renz setTitle:@"审核中" forState:UIControlStateNormal];
    }else if ([Certify isEqualToString:@"10"]) {
        [self.renz setTitle:@"认证失败" forState:UIControlStateNormal];
    }
    
    
    if ([UserImg isEqualToString:@"/Upload/defaultPhoto.png"]) {
        return;
    }else{
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,UserImg];
        NSLog(@"%@",img);
        NSURL *imgurl=[NSURL URLWithString:img];
//        UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
//        self.icon.image=imgstr;
        [self.icon setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
    }
    if ([star isEqualToString:@"1"]) {
        self.x1.hidden=NO;
    }else if ([star isEqualToString:@"2"]){
    self.x1.hidden=NO;
    self.x2.hidden=NO;
    
    }else if ([star isEqualToString:@"3"]){
        self.x1.hidden=NO;
        self.x2.hidden=NO;
         self.x3.hidden=NO;
    }else if ([star isEqualToString:@"4"]){
        self.x1.hidden=NO;
        self.x2.hidden=NO;
        self.x3.hidden=NO;
          self.x4.hidden=NO;
    }else if ([star isEqualToString:@"5"]){
        self.x1.hidden=NO;
        self.x2.hidden=NO;
        self.x3.hidden=NO;
        self.x4.hidden=NO;
        self.x5.hidden=NO;
    }

    
}

-(void)network{
    NSString *myString =[self GetUserID];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_User.ashx?action=getordernum&q0=%@",urlt,myString];
    
    NSString *str = @"type=focus-c";
    
    NSLog(@"＝＝＝＝＝＝%@",urlStr);
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:str];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=responseObject;
        NSDictionary *dict1=dict[@"ResultObject"];
        if (![dict[@"ResultObject"] isEqual:[NSNull null]]) {
             if (![dict1[@"AllNum"] isEqual:[NSNull null]]) {
              self.wdyd.text=[NSString stringWithFormat:@"%@",dict1[@"AllNum"]];
             }
            if (![dict1[@"FinishNum"] isEqual:[NSNull null]]) {
               self.wcyd.text=[NSString stringWithFormat:@"%@",dict1[@"FinishNum"]];
            }
            if (![dict1[@"NOFinishNum"] isEqual:[NSNull null]]) {
                 self.dwcyd.text=[NSString stringWithFormat:@"%@",dict1[@"NOFinishNum"]];
            }
      
     
        }
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        [MBProgressHUD showError:@"网络请求出错"];
        
        return ;
        
    }];
    
    
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
    
}

@end
