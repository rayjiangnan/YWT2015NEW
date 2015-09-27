//
//  pinjia.m
//  运维通
//
//  Created by ritacc on 15/7/25.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "pinjia.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"
#import "UIViewController+Extension.h"

@interface pinjia ()
@property (weak, nonatomic) IBOutlet UILabel *danhao;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *style;

@property (weak, nonatomic) IBOutlet UILabel *dri;

@property (weak, nonatomic) IBOutlet UILabel *bt;
@property (nonatomic,strong)NSString *idtt;

@property (weak, nonatomic) IBOutlet UITextView *py;

@property (weak, nonatomic) IBOutlet UIButton *x1;
@property (weak, nonatomic) IBOutlet UIButton *x2;

@property (weak, nonatomic) IBOutlet UIButton *x3;
@property (weak, nonatomic) IBOutlet UIButton *x4;
@property (weak, nonatomic) IBOutlet UIButton *x5;
@property (nonatomic,strong)NSString *xin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@end

@implementation pinjia
@synthesize strTtile;
@synthesize _locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager= [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.distanceFilter = 100;
    
    [_locationManager startUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    [self requestaaa];
    
    [self tapOnce];
    [self tapBackground];
    
     self.scrollview.contentSize=CGSizeMake(320, 600);
}

-(void)requestaaa
{
    NSString *myString =[self GetUserID];
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=getitem&q0=%@&q1=%@",urlt,mystring2,myString];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    NSLog(@"%@",urlStr);
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@,%d",   [NSThread mainThread],[NSThread isMainThread]);
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict2=responseObject;
        NSDictionary *dict=dict2[@"ResultObject"];
        NSLog(@"#####%@",dict);
        self.danhao.text=dict[@"OrderNo"];
//        NSString *dt3=dict[@"CreateDateTime"];
//        dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
//        dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
//        // NSLog(@"%@",dt3);
//        NSString * timeStampString3 =dt3;
//        NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
//        NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
//        NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
//        [objDateformat3 setDateFormat:@"yyyy-MM-dd"];
        self.time.text=[self DateFormartYMD:dict[@"CreateDateTime"]];//[objDateformat3 stringFromDate: date3];
        
        [self idt:dict[@"Order_ID"]];
        
        self.style.text=dict[@"Status_Name"];
        self.bt.text=dict[@"OrderTitle"];
        if (![dict[@"OrderUsers"] isEqual:[NSNull null]]) {
            NSArray *dict3=dict[@"OrderUsers"];
            NSDictionary *dic=[dict3 objectAtIndex:0];
            if (![dic[@"RealName"] isEqual:[NSNull null]]) {
                NSString *dr=[NSString stringWithFormat:@"%@  %@",dic[@"RealName"],dic[@"Mobile"]];
                self.dri.text=dr;
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
}



- (IBAction)post:(id)sender {
    [self postJSON];
}

-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}
-(NSString*) SetValue {
    
    
    
    NSString *Create_User   =[self GetUserID];
    
    //NSMutableArray *jsonArray = [[NSMutableArray alloc]init];//创建最外层的数组
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:@"0" forKey:@"Assess_Type"];
    [dic setValue:_idtt forKey:@"Order_ID"];
    [dic setValue:@"完成" forKey:@"YW_Result"];
    [dic setValue:_xin forKey:@"Score"];
    [dic setValue:self.py.text forKey:@"AssessContent"];
    [dic setValue:Create_User forKey:@"Creator"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    return jsonString;
   
}
- (void)postJSON
{
    NSString *urlstr=[NSString stringWithFormat:@"%@/API/YWT_Order.ashx",urlt];
    NSString *strparameters = [NSString stringWithFormat:@"action=orderassess&q0=%@",[self SetValue]];
    
    NSLog(@"%@?%@",urlstr,strparameters);
    AFHTTPRequestOperation *op=[self POSTurlString:urlstr parameters:strparameters];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
        }else{
             [self ChangeRecord:_idtt key:@"Order"]; //处理刷新问题
            [self ChangeRecord:_idtt key:@"Order"]; //处理刷新问题
            [MBProgressHUD showSuccess:@"评价成功！"];
            [[self navigationController] popViewControllerAnimated:YES];
            return ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
        return ;
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self requestaaa];

}

-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce
{
    [self.py resignFirstResponder];

}

- (IBAction)x1:(id)sender {
    [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x2 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x3 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x4 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x5 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    _xin=@"1";
}

- (IBAction)x2:(id)sender {
        [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
        [self.x2 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x3 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x4 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x5 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
     _xin=@"2";
    
}
- (IBAction)x3:(id)sender {
    [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x2 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
        [self.x3 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x4 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x5 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
     _xin=@"3";
    
}
- (IBAction)x4:(id)sender {
    [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x2 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x3 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
     [self.x4 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
        [self.x5 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
     _xin=@"4";
    
}
- (IBAction)x5:(id)sender {
    [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x2 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x3 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x4 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
        [self.x5 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
     _xin=@"5";
    
    
}

@end
