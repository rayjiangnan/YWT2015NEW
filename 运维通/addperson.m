//
//  addperson.m
//  
//
//  Created by 南江 on 15/5/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "addperson.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewController+Extension.h"

@interface addperson () <UIPickerViewDataSource, UIPickerViewDelegate>
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

- (IBAction)regbtn;

@end

@implementation addperson
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:nil didSelectRow:0 inComponent:component];
    }
    
    [self tapOnce];
    [self tapBackground];
    
}

- (IBAction)regbtn {
    [self postJSON];
}



-(NSString *)act{
    
    if (self.swith.on) {
        _ac=@"1";
        
    }else{
    
        _ac=@"0";
    }
    
    return _ac;
}

- (void)postJSON
{
    
    if ([self.sty.text isEqualToString:@"运维人员"]) {
        _zhi=@"20";
        
    }
    if ([self.sty.text isEqualToString:@"调度人员"]) {
        _zhi=@"30";
        
    }
    
    // 1. URL
    NSString *urlStr=[NSString stringWithFormat:@"%@/API/YWT_User.ashx",urlt];
    //NSURL *url = [NSURL URLWithString:ur];
    @try
    {
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt2"];
         
        [self getUniqueStrByUUID];
       
        _ac=@"1";

        NSString *dtr=[NSString stringWithFormat:@"{\"User\":{\"UserType\":\"%@\",\"Mobile\":\"%@\",\"RealName\":\"%@\",\"SupplierID\":\"%@\",\"PassWord\":\"%@\",\"Active\":\"1\"}}",_zhi,self.phone.text,self.realname.text,myString,self.pwd.text];
        
        NSString *strparameters = [NSString stringWithFormat:@"action=addsupuser&q0=%@",dtr];

        AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:strparameters];
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
                [MBProgressHUD showSuccess:@"保存成功"];
                [[self navigationController] popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络异常！"];
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
    }@catch (NSException * e) {
        
    }
    
}


- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
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
    [self.pwd resignFirstResponder];
    [self.cpwd resignFirstResponder];
    [self.realname resignFirstResponder];
    [self.eamil resignFirstResponder];
    [self.xueli resignFirstResponder];
}

@end
