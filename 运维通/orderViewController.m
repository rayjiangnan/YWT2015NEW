//
//  orderViewController.m
//  送哪儿
//
//  Created by apple on 15/4/27.
//  Copyright (c) 2015年 Tony. All rights reserved.
//
#import "orderViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"


@interface orderViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)reg;

//新的数据
@property (weak, nonatomic) IBOutlet UITextField *biaoti;
@property (weak, nonatomic) IBOutlet UITextField *lx;

@property (weak, nonatomic) IBOutlet UITextView *gzrw;

@property (weak, nonatomic) IBOutlet UITextField *gzsc;
@property (weak, nonatomic) IBOutlet UITextField *khjc;
@property (weak, nonatomic) IBOutlet UITextField *lxr;
@property (weak, nonatomic) IBOutlet UITextField *lxdh;
@property (weak, nonatomic) IBOutlet UITextField *dz;
@property (weak, nonatomic) IBOutlet UITextField *bz;

@property (weak, nonatomic) IBOutlet UIButton *stybtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *foods;

@property(nonatomic,copy)NSDictionary *result;


@end

@implementation orderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *mygh = [userDefaultes stringForKey:@"detaaddr"];
    
    self.khjc.text = [userDefaultes stringForKey:@"CusShort"];
    self.lxr.text=[userDefaultes stringForKey:@"ContactMan"];
    self.lxdh.text = [userDefaultes stringForKey:@"ContactMobile"];
    
    if ([mygh isEqualToString:@""]) {
          self.dz.text=[userDefaultes stringForKey:@"ContactAddress"];
    }else{
    
     self.dz.text=mygh;
    }
    [self ChangeItemInit:@"Order"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:nil didSelectRow:0 inComponent:component];
    }
    
 self.scrollview.contentSize=CGSizeMake(320, 1000);
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
    //[dic setValue: forKey:@"TaskTimeLen"];
    [dic setValue:self.lxr.text forKey:@"ContactMan"];
    
    [dic setValue:self.lxdh.text forKey:@"ContactMobile"];
    [dic setValue:self.khjc.text forKey:@"CustomerShort"];
    [dic setValue:self.bz.text forKey:@"Remark"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    
    jsonString=[NSString stringWithFormat:@"{\"OrderMain\":%@,\"OrderFile\":[]}",jsonString];
    
    return jsonString;
}

- (void)postJSON{
    @try
    {
        NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_Order.ashx",urlt];
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        NSString *jsonString =[self SetValue];
        NSString *strparameters = [NSString stringWithFormat:@"action=addinternal&q0=%@&q1=%@",jsonString,myString];
        
        
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
                [self performSegueWithIdentifier:@"order" sender:nil];
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //  isFullScreen = !isFullScreen;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    CGPoint imagePoint = self.imageView.frame.origin;
    //touchPoint.x ，touchPoint.y 就是触点的坐标
    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
    
    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <= touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
    {
        // 设置图片放大动画
        [UIView beginAnimations:nil context:nil];
        // 动画时间
        [UIView setAnimationDuration:1];
        /*
         if (isFullScreen) {
         // 放大尺寸
         
         self.imageView.frame = CGRectMake(0, 0, 320, 480);
         }
         else {
         // 缩小尺寸
         self.imageView.frame = CGRectMake(50, 65, 90, 115);
         }
         */
        // commit动画
        [UIView commitAnimations];
    }
    
}




@end
