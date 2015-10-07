//
//  login.m
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "login.h"
#import "MBProgressHUD+MJ.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIViewController+Extension.h"

@interface login ()<UIApplicationDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *useName;
@property (weak, nonatomic) IBOutlet UISwitch *rememberbtn;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (nonatomic, strong) CLLocationManager *_locationManager;
@end

@implementation login

-(void)viewDidAppear:(BOOL)animated{
    
    [self ChangePageInit:@"log"];
    [self ChangePageInit:@"Order"];
    [self ChangePageInit:@"OnlineApproval"];
    [self ChangePageInit:@"Customer"];
    [self ChangePageInit:@"Warehouse"];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *autopass = [userDefaultes stringForKey:@"autopass"];
    if ([autopass isEqualToString:@"go"]) {
        NSString *password = [userDefaultes stringForKey:@"password"];
        self.pwd.text=password;
        [self getLogon];
    }
}

- (void)viewDidLoad
{
    //清掉ID
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:NULL forKey:@"myidt"];
    
    [super viewDidLoad];
   // self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBarHidden=YES;
    
    if (![CLLocationManager locationServicesEnabled])
    { NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
        
    }
    
    NSString *strphone= [userDefaults stringForKey:@"iphone"];
    if(strphone != nil)
    {
        self.useName.text=strphone;
    }

    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dl_ren.png"]];
    self.useName.leftView=image;
    self.useName.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *image2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dl_suo.png"]];
    self.pwd.leftView=image2;
    self.pwd.leftViewMode = UITextFieldViewModeAlways;
    [self tapBackground];
    [self tapOnce];

}

- (IBAction)login:(id)sender {
    [self getLogon];
}
- (void)getLogon
{
    
    @try
    {
        NSUUID *uuid=[UIDevice currentDevice].identifierForVendor;
        NSString *uuidstr=uuid.UUIDString;
        NSString *uuids=[NSString stringWithFormat:@"%@0000",uuidstr];
        
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        
        NSString *os=[NSString stringWithFormat:@"ios%@",phoneVersion];
        
        NSString* phoneModel = [[UIDevice currentDevice] model];
        NSString* xh;
        xh=[NSString stringWithFormat:@"%@",phoneModel];
        
        if([xh isEqualToString:@"iPhone Simulator"])
        {
            xh=@"iPhone";
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_User.ashx?action=login&q0=%@&q1=%@&q2=%@&q3=%@&q4=%@",urlt,self.useName.text, self.pwd.text,uuids,os,xh];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSLog(@"%@",urlStr);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (data != nil) {
                NSMutableDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
                        if ([Status isEqualToString:@"0"]){
                            [MBProgressHUD showError:@"账号或密码错误！"];
                            return ;
                        }
                    
                       NSDictionary *dict=json[@"ResultObject"];
                    
                        NSString *idt=[NSString stringWithFormat:@"%@",dict[@"ID"]];
                        NSString *idt2=[NSString stringWithFormat:@"%@",dict[@"SupplierID"]];
                        NSString *RealName=[NSString stringWithFormat:@"%@",dict[@"RealName"]];
                        NSString *Company=[NSString stringWithFormat:@"%@",dict[@"Company"]];
                        NSString *usertype=[NSString stringWithFormat:@"%@",dict[@"UserType"]];
                        NSString *UserImg=[NSString stringWithFormat:@"%@",dict[@"UserImg"]];
                        NSString *Mobile=[NSString stringWithFormat:@"%@",dict[@"Mobile"]];
                        NSString *Certify=[NSString stringWithFormat:@"%@",dict[@"Certify"]];
                        
                        BOOL SuppAdmin=[dict[@"SuppAdmin"] boolValue];
                    
                        if ([usertype isEqualToString:@"10"]&[idt2 isEqualToString:@""]) {
                            [MBProgressHUD showSuccess:@"请完善账号！"];
                            [self performSegueWithIdentifier:@"wan" sender:nil];
                        }
                        else
                        {
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            [userDefaults setObject:idt forKey:@"myidt"];
                            [userDefaults setObject:idt2 forKey:@"myidt2"];
                            [userDefaults setObject:self.useName.text forKey:@"iphone"];
                            [userDefaults setObject:self.pwd.text forKey:@"password"];
                            [userDefaults setObject:RealName forKey:@"RealName"];
                            [userDefaults setObject:Company forKey:@"Company"];
                            [userDefaults setObject:usertype forKey:@"usertype"];
                            [userDefaults setObject:UserImg forKey:@"UserImg"];
                            [userDefaults setObject:Certify forKey:@"Certify"];
                            [userDefaults setObject:Mobile forKey:@"Mobile"];
                            [userDefaults setInteger:1 forKey:@"changeKey"];
                            [userDefaults setBool:SuppAdmin forKey:@"SuppAdmin"];
                            
                            [userDefaults synchronize];
                       
                            if ([idt2 isEqualToString:@""]&[usertype isEqualToString:@"0"])
                            {
                                [self performSegueWithIdentifier:@"wan" sender:nil];
                                [MBProgressHUD showSuccess:@"请完善账号设置！"];
                            }
                            else
                            {
                                NSString *autopass=@"";
                                if (self.rememberbtn.on) {
                                    autopass=@"go";
                                    [userDefaults setObject:self.pwd.text forKey:@"password"];
                                }
                                [userDefaults setObject:autopass forKey:@"autopass"];
                                
                                [MBProgressHUD showSuccess:@"登录成功！"];
                                if ([usertype isEqualToString:@"10"]) {
                                
                                     [self performSegueWithIdentifier:@"login" sender:nil];
                                }else if ([usertype isEqualToString:@"30"]) {
                                    
                                    [self performSegueWithIdentifier:@"login" sender:nil];
                                }else if ([usertype isEqualToString:@"20"]) {
                                    
                                      [self performSegueWithIdentifier:@"sj" sender:nil];
                                }else if ([usertype isEqualToString:@"40"]) {
                                    
                                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                    [userDefaults setObject: [NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"Stars"]] forKey:@"star"];
                                   
                                    [self performSegueWithIdentifier:@"3yw" sender:nil];
                                }
                                
                            }
                        }
                                               
                    
                    
    
                }];
            }
        }];
    }@catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        
    }
    
}



-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}


-(void)tapOnce
{
    [self.useName resignFirstResponder];
    [self.pwd resignFirstResponder];
    
    
}
@end
