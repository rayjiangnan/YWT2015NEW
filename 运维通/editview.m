//
//  editview.m
//  
//
//  Created by 南江 on 15/5/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "editview.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewController+Extension.h"

@interface editview ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *foods;
@property (weak, nonatomic) IBOutlet UITextField *sty;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *realname;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *cpwd;
@property (weak, nonatomic) IBOutlet UIButton *stybtn;
@property (weak, nonatomic) IBOutlet UISwitch *swith;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *bdate;
@property (weak, nonatomic) IBOutlet UITextField *eamil;
@property (weak, nonatomic) IBOutlet UITextField *xueli;
@property (nonatomic,copy)NSString *uuid;
@property (nonatomic,copy)NSString *zhi;
@property (nonatomic,copy)NSString *ac;
@property (weak, nonatomic) IBOutlet UIButton *xiugai;

@end

@implementation editview
@synthesize strTtile;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:nil didSelectRow:0 inComponent:component];
    }
    
    [self network];

    [self tapOnce];
    [self tapBackground];
    
}

- (IBAction)regbtn {
    
    if ([self.username.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入登陆名！"];
        return;
    }else if([self.realname.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入真实姓名！"];
        return;
    }else if([self.phone.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入真实的手机号！"];
        return;
    }else{
        
  [self postJSON:self.phone.text:self.realname.text];
        [MBProgressHUD showSuccess:@"修改成功"];
[[self navigationController] popViewControllerAnimated:YES];
    }
    
    
    
}


-(void)network{
 
 
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
       NSString *myString = [userDefaultes stringForKey:@"personid"];
         NSString *myString2  =[self GetUserID];      //  NSString *mystring2=[NSString
    
        NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getasupuser&q0=%@&q1=%@",urlt,myString,myString2];
        
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
        }
        
        NSDictionary *dictarr2=[json objectForKey:@"ResultObject"];
        NSDictionary *dictarr=[dictarr2 objectForKey:@"User"];


        NSString *stye=[NSString stringWithFormat:@"%@",dictarr[@"UserType"]];
        if ([stye isEqualToString:@"20"]) {
            self.sty.text=@"运维人员";
        }
        else if ([stye isEqualToString:@"30"])
        {
            self.sty.text=@"调度人员";
        }
        if ([stye isEqualToString:@"10"]) {
            self.xiugai.hidden=YES;
        }
        self.username.text=dictarr[@"UserName"];
        self.sex.text=dictarr[@"UserName"];
        self.realname.text=dictarr[@"RealName"];
        self.phone.text=dictarr[@"Mobile"];
        NSString *hg=[NSString stringWithFormat:@"%@",dictarr[@"Active"]];

        if ([hg isEqualToString:@"1"]) {
            [self.swith setOn:YES];
        }else{
            [self.swith setOn:NO];
        }
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [MBProgressHUD showError:@"网络异常！"];
         return ;
     }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}


- (void)postJSON:(NSString *)text1 :(NSString *)text2
{

        NSString *strurl=[NSString stringWithFormat:@"%@/API/YWT_User.ashx",urlt];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt2"];
    NSString *mystring2 = [userDefaultes stringForKey:@"personid"];

    [self quzhi];
    [self act];
    NSString *dstr=[NSString stringWithFormat:@"{\"ID\":\"%@\",\"Mobile\":%@, \"UserType\":\"%@\",\"SupplierID\":\"%@\", \"RealName\":\"%@\", \"Active\":%@}",mystring2,text1,_zhi,myString,text2,_ac];
    NSLog(@"---%@",dstr);
    // ? 数据体
    NSString *strparameters = [NSString stringWithFormat:@"action=edit&q0=%@",dstr];
 
    AFHTTPRequestOperation *op=[self POSTurlString:strurl parameters:strparameters];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
            return ;
        }
        [MBProgressHUD showSuccess:@"修改成功"];
        [[self navigationController] popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];

}
-(NSString *)quzhi{
    
    if ([self.sty.text isEqualToString:@"运维人员"]) {
        _zhi=@"20";
        
    }
    if ([self.sty.text isEqualToString:@"调度人员"]) {
        _zhi=@"30";
        
    }
    return _zhi;
}



-(NSString *)act{

    if ([self.swith isOn]) {
        NSString *kc=@"1";
        _ac=kc;
    }else{
        
        NSString *kc=@"0";
        _ac=kc;
    }
    
    return _ac;
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    _uuid=uuidString;
    return _uuid;
    
}



- (NSArray *)foods
{
    if (_foods == nil) {
        
        _foods = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"name" ofType:@"plist"]];
    }
    return _foods;
}

#pragma mark - 数据源方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.foods.count;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *subfoods = self.foods[component];
    return subfoods.count;
}

#pragma mark - 代理方法

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.foods[component][row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.sty.text = self.foods[component][row];
    }
}

- (IBAction)selcetsty:(id)sender {
    self.pickerView.hidden=NO;
    self.stybtn.hidden=NO;
    
}
- (IBAction)querensty:(id)sender {
    self.pickerView.hidden=YES;
    self.stybtn.hidden=YES;
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
    [self.phone resignFirstResponder];
    [self.realname resignFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *g2=@"";
    [userDefaults setObject:g2 forKey:@"personid"];


    
}


@end
