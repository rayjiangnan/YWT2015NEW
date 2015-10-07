//
//  ritaccreg2.m
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "ritaccreg2.h"
#import "MBProgressHUD+MJ.h"


@interface ritaccreg2 ()
@property(nonatomic,copy)NSString *IDF;
@property (weak, nonatomic) IBOutlet UITextField *cname;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *realname;
@property (weak, nonatomic) IBOutlet UITextField *sty;
@property (weak, nonatomic) IBOutlet UIButton *stybtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *foods;

@end

@implementation ritaccreg2



- (void)viewDidLoad
{
    [super viewDidLoad];
//    for (int component = 0; component < self.foods.count; component++) {
//        [self pickerView:nil didSelectRow:0 inComponent:component];
//    }
    [self tapBackground];
    [self tapOnce];

}
- (void)postJSON1{
    
    NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_Supplier.ashx",urlt];
  
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myid = [userDefaultes stringForKey:@"myid"];
    NSString *iphone=[userDefaultes stringForKey:@"iphone"];
        
        NSString *dstr=[NSString stringWithFormat:@"{\"Company\":\"%@\",\"RealName\":\"%@\",\"Mobil\":\"%@\",\"UserType\":\"10\",\"Active\":\"1\"}",self.cname.text,self.realname.text,iphone];
    
        NSString *strparameters = [NSString stringWithFormat:@"action=addupdate&q0=%@&q1=%@",dstr,myid];
    
        AFHTTPRequestOperation *op=  [self POSTurlString:strurl parameters:strparameters];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *json=responseObject;
            
            NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
            if ([Status isEqualToString:@"0"]){
                NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
                [MBProgressHUD showError:ReturnMsg];
                NSLog(@"%@",ReturnMsg);
                return;
            }
            else
            {
                [MBProgressHUD showSuccess:@"恭喜您，注册成功！"];
                [self performSegueWithIdentifier:@"fanhui1" sender:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络异常！"];
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
}

- (IBAction)fghZ:(id)sender {
    self.stybtn.hidden=YES;
    self.pickerView.hidden=YES;
    if ([self.sty.text isEqualToString:@"运维商"]) {
        self.cname.hidden=NO;
        self.tel.hidden=NO;
    }else{
        self.cname.hidden=YES;
        self.tel.hidden=YES;
    }
}


- (IBAction)selcetsty:(id)sender {
    self.pickerView.hidden=NO;
    self.stybtn.hidden=NO;
    
}

- (void)postJSON2:(NSString *)RealName {
    
    NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_User.ashx",urlt];
    @try
    {
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myid = [userDefaultes stringForKey:@"myid"];
        NSString *iphone=[userDefaultes stringForKey:@"iphone"];
        
        NSString *dstr=[NSString stringWithFormat:@"{\"ID\":\"%@\",\"RealName\":\"%@\",\"UserType\":\"40\",\"Mobile\":\"%@\",\"Active\":\"1\"}",myid,RealName,iphone];
     
        
        NSString *strparameters = [NSString stringWithFormat:@"action=edit&q0=%@",dstr];
        AFHTTPRequestOperation *op=  [self POSTurlString:strurl parameters:strparameters];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *json=responseObject;
            
            NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
            if ([Status isEqualToString:@"0"]){
                NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
                [MBProgressHUD showError:ReturnMsg];
                NSLog(@"%@",ReturnMsg);
                return;
            }
            else
            {
                [MBProgressHUD showSuccess:@"恭喜您，注册成功！"];
                [self performSegueWithIdentifier:@"fanhui1" sender:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络异常！"];
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
    }@catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        UIAlertView * alert = [
                               [UIAlertView alloc]
                               initWithTitle:@"错误"
                               message: [[NSString alloc] initWithFormat:@"网络连接异常"]
                               delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}



- (IBAction)TIJIAO:(id)sender {

    if ([self.sty.text isEqualToString:@"运维商"]) {
        if ([self.realname.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入姓名"];
            return;
        }else if ([self.cname.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入公司名称"];
            return;
        }else if ([self.tel.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入联系电话"];
            return;
        }else{
            [self postJSON1];
        }

    }else {
          if ([self.realname.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入姓名"];
            return;
        }else{
            [self postJSON2:self.realname.text];
        }
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
    [self.cname resignFirstResponder];
    [self.realname resignFirstResponder];
    [self.tel resignFirstResponder];
    
}

@end
