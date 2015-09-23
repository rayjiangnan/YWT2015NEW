//
//  qiang.m
//  运维通
//
//  Created by ritacc on 15/7/25.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "qiang.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"

@interface qiang ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)reg;

//新的数据
@property (weak, nonatomic) IBOutlet UITextField *biaoti;
@property (weak, nonatomic) IBOutlet UITextField *lx;
@property (weak, nonatomic) IBOutlet UITextView *gzrw;

@property (weak, nonatomic) IBOutlet UITextField *gzsc;
@property (weak, nonatomic) IBOutlet UITextField *ywfy;
@property (weak, nonatomic) IBOutlet UITextField *xqrs;
@property (weak, nonatomic) IBOutlet UITextField *nlyq;

@property (weak, nonatomic) IBOutlet UITextField *khjc;
@property (weak, nonatomic) IBOutlet UITextField *lxr;
@property (weak, nonatomic) IBOutlet UITextField *lxdh;
@property (weak, nonatomic) IBOutlet UITextField *dz;
@property (weak, nonatomic) IBOutlet UITextView *bz;



@property (weak, nonatomic) IBOutlet UIButton *stybtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *foods;

@property(nonatomic,copy)NSDictionary *result;


@end

@implementation qiang


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *mygh = [userDefaultes stringForKey:@"detaaddr"];
    NSString *iphone=[userDefaultes stringForKey:@"iphone"];
    self.lxdh.text=iphone;
    self.dz.text=mygh;
    
    [self ChangeItemInit:@"Order"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:nil didSelectRow:0 inComponent:component];
    }
    
    self.scrollview.contentSize=CGSizeMake(320, 1300);
    self.navigationController.navigationBar.hidden=NO;
    [self tapBackground];
    
    
}

- (IBAction)fghZ:(id)sender {
    self.stybtn.hidden=YES;
    self.pickerView.hidden=YES;
    
}


- (IBAction)selcetsty:(id)sender {
    self.pickerView.hidden=NO;
    self.stybtn.hidden=NO;
    
}

- (NSArray *)foods
{
    if (_foods == nil) {
        
        _foods = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"styname" ofType:@"plist"]];
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
        self.lx.text = self.foods[component][row];
    }
}



- (IBAction)reg {
    [self postJSON];
}

-(NSString*) SetValue {
    NSString *sty=[[NSString alloc]init];
    if ([self.lx.text isEqualToString:@"业务运维"]) {
        sty=@"BusinessOperations";
    } else if ([self.lx.text isEqualToString:@"网络设备"]) {
        sty=@"NetworkEquipment";
    }else if ([self.lx.text isEqualToString:@"操作系统"]) {
        sty=@"OperatingSystem";
    }else if ([self.lx.text isEqualToString:@"服务器设备"]) {
        sty=@"ServerEquipment";
    }
    
    
    //NSMutableArray *jsonArray = [[NSMutableArray alloc]init];//创建最外层的数组
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:self.biaoti.text forKey:@"OrderTitle"];
    [dic setValue:sty forKey:@"OrderType"];
    [dic setValue:self.gzrw.text forKey:@"OrderTask"];
    [dic setValue:self.dz.text forKey:@"Task_Address"];
    
    NSString *timelen=self.gzsc.text;
    
    if ([self isBlankString:timelen] == NO) {
        [dic setValue:timelen forKey:@"TaskTimeLen"];
    }

    [dic setValue:self.lxr.text forKey:@"ContactMan"];
    
    [dic setValue:self.lxdh.text forKey:@"ContactMobile"];
    [dic setValue:self.khjc.text forKey:@"CustomerShort"];
    [dic setValue:self.bz.text forKey:@"Remark"];
    
    [dic setValue:self.ywfy.text forKey:@"Freight"];
    [dic setValue:self.xqrs.text forKey:@"PersonNum"];
    [dic setValue:self.nlyq.text forKey:@"AbilityRequest"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    
    jsonString=[NSString stringWithFormat:@"{\"OrderMain\":%@,\"OrderFile\":[]}",jsonString];
    
    return jsonString;
}



- (void)postJSON{
    @try
    {
        NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_OrderPlatform.ashx",urlt];
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *Userid = [userDefaultes stringForKey:@"myidt"];
        NSString *dstr=[self SetValue];
        NSString *strparameters = [NSString stringWithFormat:@"action=addexternal&q0=%@&q1=%@",dstr,Userid];
        
            
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
                [self ChangeRecordAdd:@"Order"];
                [MBProgressHUD showSuccess:@"下单成功！"];
                [[self navigationController] popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络异常！"];
            return ;
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
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
    
    [self.biaoti resignFirstResponder];
    [self.lx resignFirstResponder];
    [self.gzrw resignFirstResponder];
    [self.gzsc resignFirstResponder];
    [self.khjc resignFirstResponder];
    [self.lxr resignFirstResponder];
    [self.lxdh resignFirstResponder];
    [self.dz resignFirstResponder];
    [self.bz resignFirstResponder];
    
}

@end
