//
//  ritaccreg.m
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "ritaccreg.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"

@interface ritaccreg ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *cpwd;
@property (weak, nonatomic) IBOutlet UIButton *regbtn;



@end

@implementation ritaccreg



- (void)viewDidLoad
{
    [super viewDidLoad];
      [self tapBackground];
    [self tapOnce];


}



- (IBAction)reg:(id)sender {
    
    if ([self.username.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入账号"];
        return;
    }else if([self.pwd.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }else if(![self.pwd.text isEqualToString:self.cpwd.text]){
        [MBProgressHUD showError:@"两次密码不一致请重新输入"];
        return;
    }else{
        [self postJSON];
    }
}

-(NSString*) SetValue {
    NSUUID *uuid=[UIDevice currentDevice].identifierForVendor;
    NSString *uuidstr=uuid.UUIDString;
    NSString *uuids=[NSString stringWithFormat:@"%@0000",uuidstr];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString *os=[NSString stringWithFormat:@"ios%@",phoneVersion];
    //NSString* phoneModel = [[UIDevice currentDevice] model];
    //NSString* xh=[NSString stringWithFormat:@"%@",phoneModel];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:self.pwd.text forKey:@"PassWord"];
    [dic setValue:self.username.text forKey:@"Mobile"];
    [dic setValue:@"" forKey:@"RealName"];
    [dic setValue:0 forKey:@"UserType"];
    
    [dic setValue:uuids forKey:@"IMEI"];
    [dic setValue:os forKey:@"OS"];
    
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    
    jsonString=[NSString stringWithFormat:@"action=reg&q0=%@",jsonString];
    
    return jsonString;
}


- (void)postJSON{
    
    NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_User.ashx",urlt];
       
    NSString *strparameters=[self SetValue];
    
    AFHTTPRequestOperation *op=  [self POSTurlString:strurl parameters:strparameters];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
            return ;
        }else{
            NSDictionary *dict3= json[@"ResultObject"];
            NSString *myid=[NSString stringWithFormat:@"%@",dict3[@"ID"]];
            NSString *mystyle=[NSString stringWithFormat:@"%@",dict3[@"UserType"]];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setObject:self.username.text forKey:@"iphone"];
            [userDefaults setObject:myid forKey:@"myid"];
            [userDefaults setObject:mystyle forKey:@"mystyle"];
            [userDefaults synchronize];
            [MBProgressHUD showSuccess:@"恭喜您注册成功，只剩最后一步了哦！"];
            [self performSegueWithIdentifier:@"zc" sender:nil];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
}

-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}


-(void)tapOnce
{
    [self.username resignFirstResponder];
    [self.pwd resignFirstResponder];
    [self.cpwd resignFirstResponder];
    
}

@end
