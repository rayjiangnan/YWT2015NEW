//
//  postapply.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "postapply.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"

@interface postapply ()
@property (weak, nonatomic) IBOutlet UITextField *lxr;
@property (weak, nonatomic) IBOutlet UITextField *dh;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextView *nr;

@end

@implementation postapply
@synthesize strTtile;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *RealName = [userDefaultes stringForKey:@"RealName"];
     NSString *iphone = [userDefaultes stringForKey:@"iphone"];
    self.lxr.text=RealName;
    self.dh.text=iphone;

    
    [self tapBackground];
    [self tapOnce];
    
    [self ChangeItemInit:@"Order"];
}

- (IBAction)post:(id)sender {
    [self tijiao2];
}

-(NSString*) SetValue {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Userid = [userDefaultes stringForKey:@"myidt"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:strTtile forKey:@"Order_ID"];
    [dic setValue:Userid forKey:@"Apply_UserID"];
    [dic setValue:self.nr.text forKey:@"Apply_Content"];
    [dic setValue:self.lxr.text forKey:@"ContactMan"];
    [dic setValue:self.dh.text forKey:@"ContactMobile"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    jsonString = [NSString stringWithFormat:@"action=applyyw&q0=%@&q1=%@",jsonString,Userid];
    return jsonString;
}

-(void)tijiao2{
    NSString *urlStr =[NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx",urlt] ;
    NSString *strparameters=[self SetValue];
    
    AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:strparameters];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
            return;
        }else{
            [self ChangeRecord:strTtile key:@"Order"];
            [MBProgressHUD showSuccess:@"申请成功！"];
            [[self navigationController] popViewControllerAnimated:YES];
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
    
    [self.lxr resignFirstResponder];
    [self.dh resignFirstResponder];
    [self.time resignFirstResponder];
    [self.nr resignFirstResponder];
}

@end
