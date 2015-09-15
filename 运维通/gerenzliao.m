//
//  gerenzliao.m
//  运维通
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "gerenzliao.h"
#import "MBProgressHUD+MJ.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Extension.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "SBJson.h"

@interface gerenzliao ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,NSURLConnectionDelegate,UITextFieldDelegate>
{
    int sexnum;
}
@property (weak, nonatomic) IBOutlet UILabel *sty;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *sheng;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *qu;
@property (weak, nonatomic) IBOutlet UITextField *detail;
@property (weak, nonatomic) IBOutlet UITextField *xueli;
@property (weak, nonatomic) IBOutlet UITextField *xuexiao;
@property (weak, nonatomic) IBOutlet UITextField *zhuanye;
@property (weak, nonatomic) IBOutlet UITextField *btime;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextView *jineng;
@property (weak, nonatomic) IBOutlet UITextView *zc;

@property (weak, nonatomic) IBOutlet UIImageView *men;

@property (weak, nonatomic) IBOutlet UIImageView *wem;

@property(nonatomic,copy)NSString *time1;
@property(nonatomic,copy)NSString *time2;

@end

@implementation gerenzliao

- (void)viewDidLoad {
    [super viewDidLoad];
    [self network];
    self.scrollView.contentSize=CGSizeMake(320,830);
    self.jineng.layer.borderColor = UIColor.grayColor.CGColor;
     self.jineng.layer.borderWidth = 0.5;
     self.zc.layer.borderColor = UIColor.grayColor.CGColor;
    self.zc.layer.borderWidth = 0.5;
    [self settingKeyboard];
    [self settingKeyboard2];

}
- (IBAction)nanbtn:(id)sender {
    sexnum=1;
    self.men.image=[UIImage imageNamed:@"ch2"];
      self.wem.image=[UIImage imageNamed:@"ch1"];
    
}

- (IBAction)nvbtn:(id)sender {
     sexnum=2;
    self.men.image=[UIImage imageNamed:@"ch1"];
    self.wem.image=[UIImage imageNamed:@"ch2"];
}


-(void)network{
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getasupuser&q0=%@&q1=%@",urlt,myString,myString];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"type=focus-c";//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    if (data==nil) {
        return;
    }else{
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dictarr2=[dict objectForKey:@"ResultObject"];
        NSLog(@"---%@",dict);
        NSDictionary *dictarr=[dictarr2 objectForKey:@"User"];

        NSString *sty=[NSString stringWithFormat:@"%@",dictarr[@"UserType"]];
        if ([sty isEqualToString:@"10"]) {
            self.sty.text=@"维运商";
        }else if([sty isEqualToString:@"20"]){
            self.sty.text=@"维运人员";
        }else if([sty isEqualToString:@"40"]){
            self.sty.text=@"调度";}
        self.tel.text=dictarr[@"UserName"];
        self.name.text=dictarr[@"RealName"];
        

        if (![[dictarr2 objectForKey:@"UserInfo"] isEqual:[NSNull null]]) {
            NSDictionary *dictarr3=[dictarr2 objectForKey:@"UserInfo"];
             self.email.text=dictarr3[@"Email"];
            self.city.text=dictarr3[@"Location_Province"];
            self.city.text=dictarr3[@"Location_City"];
            self.qu.text=dictarr3[@"Location_County"];
            self.detail.text=dictarr3[@"User_Address"];
            self.xueli.text=dictarr3[@"HighestEducation"];
            self.xuexiao.text=dictarr3[@"Finish_School"];
            self.zhuanye.text=dictarr3[@"SpecialtyName"];
            
            self.jineng.text=dictarr3[@"SkillDescription"];
            self.zc.text=dictarr3[@"Specialty"];
            
            NSString *sex=dictarr3[@"User_Sex"];
            if ([sex isEqualToString:@"男"]) {
                self.men.image=[UIImage imageNamed:@"ch2"];
                sexnum=1;
            }else  if ([sex isEqualToString:@"女"]) {
                self.wem.image=[UIImage imageNamed:@"ch2"];
                sexnum=2;
            }
            
         
//            NSString *dt1=dictarr3[@"Birthday"];
//            dt1=[dt1 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
//            dt1=[dt1 stringByReplacingOccurrencesOfString:@")/" withString:@""];
//            //NSLog(@"%@",dt1);
//            NSString * timeStampString =dt1;
//            NSTimeInterval _interval=[timeStampString doubleValue] / 1000;
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
//            NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
//            [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
//            
//            // NSLog(@"%@",dt1);
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateStyle:NSDateFormatterMediumStyle];
//            [formatter setTimeStyle:NSDateFormatterShortStyle];
//            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//            
//            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//            [formatter setTimeZone:timeZone];
//            
//            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//            
//            NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
//            //时间转时间戳的方法:
//            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//            //  NSLog(@"timeSp:%@",timeSp); //时间戳的值
//            //时间戳转时间的方法
//            double d = [dt1 doubleValue];
//            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:d];
//            //  NSLog(@"%f  = %@",d,confromTimesp);
//            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//            // NSLog(@"confromTimespStr =  %@",confromTimespStr);
//            self.time.text=confromTimespStr;
            
            self.time.text=[self DateFormartYMD:dictarr3[@"Birthday"]];
            self.btime.text=[self DateFormartYMD:dictarr3[@"GraduationData"]];
            
//            NSString *dt4=dictarr3[@"GraduationData"];
//            dt4=[dt4 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
//            dt4=[dt4 stringByReplacingOccurrencesOfString:@")/" withString:@""];
//           NSLog(@"+++++++++%@",dt4);
//            NSString * timeStampString4 =dt4;
//            NSTimeInterval _interval4=[timeStampString4 doubleValue] / 1000;
//            NSDate *date4 = [NSDate dateWithTimeIntervalSince1970:_interval4];
//            NSDateFormatter *objDateformat4 = [[NSDateFormatter alloc] init];
//            [objDateformat4 setDateFormat:@"yyyy-MM-dd"];
//            
//            self.btime.text=[objDateformat4 stringFromDate: date4];
        }
 
    }
}
-(NSString*) SetValue {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    NSLog(@"%@",Create_User);
    
    NSString *sex=@"男";
    if(sexnum==2){
        sex=@"女";
    }
    NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time1];
    NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time2];
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:Create_User forKey:@"YWTUser_ID"];
    [dic setValue:Create_User forKey:@"Create_User"];
    [dic setValue:sex forKey:@"User_Sex"];
    
    [dic setValue:@"" forKey:@"Location_Province"];
    [dic setValue:@"" forKey:@"Location_City"];
    [dic setValue:@"" forKey:@"Location_County"];
    [dic setValue:self.detail.text forKey:@"User_Address"];
    [dic setValue:self.xueli.text forKey:@"HighestEducation"];
    

    [dic setValue:timet1 forKey:@"Birthday"];
    [dic setValue:self.email.text forKey:@"Email"];
    
     [dic setValue:self.xuexiao.text forKey:@"Finish_School"];
     [dic setValue:self.zhuanye.text forKey:@"SpecialtyName"];
     [dic setValue:timet2 forKey:@"GraduationData"];
    
    [dic setValue:self.jineng.text forKey:@"SkillDescription"];
    [dic setValue:self.zc.text forKey:@"Specialty"];
    
    
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    return jsonString;
}

- (void)postJSON{
    
        NSString *strurl=[NSString stringWithFormat:@"%@/API/YWT_User.ashx",urlt];
        NSString *dstr=[self SetValue];
        NSString *strparameters = [NSString stringWithFormat:@"action=editselfinfo&q0=%@",dstr];
    
        NSLog(@"%@",dstr);
    
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
                [MBProgressHUD showSuccess:@"保存成功！"];
                [[self navigationController] popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络异常！"];
            return ;
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
}

- (IBAction)tijiao:(id)sender {
    [self postJSON];
//    if ([self.sty.text isEqualToString:@"维运商"]) {
//        
//        
//        
//        
//        
//    }else if ([self.sty.text isEqualToString:@"维运人员"]) {
//       NSString *timeSp=@"1331121231000";
//        NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time1];
//        NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time2];
//        NSString *te=@"20";
//        NSString *sex;
//        if (sexnum==1) {
//           sex=@"男";
//        }else if(sexnum==2){
//            sex=@"女";
//        }
//        
//          [self postJSON:sex:self.sheng.text:self.city.text:self.qu.text:self.detail.text:timet1:self.email.text:self.xueli.text:self.xuexiao.text:self.zhuanye.text:timet2:self.jineng.text:self.zc.text];
//        [MBProgressHUD showSuccess:@"修改成功"];
//        [[self navigationController] popViewControllerAnimated:YES];
//        
//    }else{
//        NSString *timeSp=@"1331121231000";
//        NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time1];
//        NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time2];
//        NSString *te=@"30";
//        NSString *sex;
//        if (sexnum==1) {
//           sex=@"男";
//        }else if(sexnum==2){
//            sex=@"女";
//        }
//        
//            [self postJSON:sex:self.sheng.text:self.city.text:self.qu.text:self.detail.text:timet1:self.email.text:self.xueli.text:self.xuexiao.text:self.zhuanye.text:timet2:self.jineng.text:self.zc.text];
// 
//        
//    }
    
}






#pragma mark 设置键盘
- (IBAction)ij:(id)sender {

    
}


- (IBAction)ij2:(id)sender {

    
}




- (void)settingKeyboard
{

    UIDatePicker *datePicker4 = [[UIDatePicker alloc] init];
    datePicker4.datePickerMode = UIDatePickerModeDate; // 只显示日期5
    datePicker4.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    
    [datePicker4 addTarget:self action:@selector(birthdayChange:) forControlEvents:UIControlEventValueChanged];
    
    _time.inputView = datePicker4; // 设置键盘为日期选择控件
    
    UIToolbar *tool=[[UIToolbar alloc]init];
    tool.frame=CGRectMake(0, 0, 320, 44);
    tool.barTintColor=[UIColor blackColor];
    
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(quxiao)];
    item1.tintColor=[UIColor whiteColor];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(tapOnce)];
    item2.tintColor=[UIColor whiteColor];
    tool.items=@[item1,item2];
    _time.inputAccessoryView=tool;
    
    
    _time.delegate = self;
    
}
-(void)quxiao{
    
   self.time.text=nil;
    [self tapOnce];
}

-(void)quxiao2{
    
  self.btime.text=nil;
    [self tapOnce];
}


- (NSString *)birthdayChange:(UIDatePicker *)picker
{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY-MM-dd";
    NSString* timeStr =[fmt stringFromDate:picker.date];
    _time.text=timeStr;
    
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[picker.date timeIntervalSince1970]];
     NSLog(@"时间戳----%@",timeSp);
    _time1=timeSp;
    
    return _time1;
}




- (void)settingKeyboard2
{
    // 1.生日
    UIDatePicker *datePicker5 = [[UIDatePicker alloc] init];
    datePicker5.datePickerMode = UIDatePickerModeDate; // 只显示日期5
    datePicker5.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    
    [datePicker5 addTarget:self action:@selector(birthdayChange2:) forControlEvents:UIControlEventValueChanged];
    
    _btime.inputView = datePicker5; // 设置键盘为日期选择控件
    
    UIToolbar *tool=[[UIToolbar alloc]init];
    tool.frame=CGRectMake(0, 0, 320, 44);
    tool.barTintColor=[UIColor blackColor];
    
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(quxiao2)];
    item1.tintColor=[UIColor whiteColor];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(tapOnce)];
    item2.tintColor=[UIColor whiteColor];
    tool.items=@[item1,item2];
    
    _btime.inputAccessoryView=tool;
    
    
    _btime.delegate = self;
}
- (NSString *)birthdayChange2:(UIDatePicker *)picker
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY-MM-dd";
    NSString* timeStr =[fmt stringFromDate:picker.date];
    _btime.text=timeStr;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[picker.date timeIntervalSince1970]];
    NSLog(@"时间戳----%@",timeSp);
    _time2=timeSp;
    
    return _time2;
}


-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}


-(void)tapOnce
{
    [self.time resignFirstResponder];
    [self.btime resignFirstResponder];

}
@end
