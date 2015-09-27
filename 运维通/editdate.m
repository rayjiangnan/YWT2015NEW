//
//  editdate.m
//  运维通
//
//  Created by abc on 15/8/4.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "editdate.h"
#import "MBProgressHUD+MJ.h"
#import "SBJson.h"
#import "UIViewController+Extension.h"

@interface editdate ()
@property (weak, nonatomic) IBOutlet UITextField *bt;
@property (weak, nonatomic) IBOutlet UITextView *nr;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;



@end

@implementation editdate
@synthesize strTtile;


-(void)viewDidAppear:(BOOL)animated{
    [self ChangeItemInit:@"log"];
    self.tabBarController.tabBar.hidden=YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self network];
    [self tapOnce];
    [self tapBackground];
     self.scrollview.contentSize=CGSizeMake(320, 800);
}

-(void)network{     
    NSString *myString =[self GetUserID];
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_YWLog.ashx?action=getitem&q0=%@&q1=%@",urlt,myString,mystring2];
    
    NSString *str = @"type=focus-c";

    NSLog(@"%@",urlStr);
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:str];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=responseObject;
        
        NSDictionary *dict1=dict[@"ResultObject"];
        NSLog(@"%@",dict1);
        self.bt.text=dict1[@"Title"];
        self.nr.text=dict1[@"Content"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}


- (IBAction)save:(id)sender {
    
    [self postJSON:@"0"];
}

- (IBAction)post:(id)sender {
 
    
    [self postJSON:@"1"];
    
    
}
- (void)postJSON:(NSString *)LogStatus

{
    NSString *myString =[self GetUserID];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@/API/YWT_YWLog.ashx",urlt];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:myString forKey:@"UserID"];
    [dic setValue:self.bt.text forKey:@"Title"];
    [dic setValue:self.nr.text forKey:@"Content"];
    [dic setValue:LogStatus forKey:@"LogStatus"];
    [dic setValue:strTtile forKey:@"LogID"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    

    NSString *str = [NSString stringWithFormat:@"action=addedit&q0=%@&q1=%@",jsonString,@""];
    
    NSLog(@"%@?%@",urlstr,str);    
    
    AFHTTPRequestOperation *op=[self POSTurlString:urlstr parameters:str];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=responseObject;
        NSString *sta=[NSString stringWithFormat:@"%@",dict[@"Status"]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([sta isEqualToString:@"1"]){
                [MBProgressHUD showSuccess:@"提交成功！"];
                
                [[self navigationController] popViewControllerAnimated:YES];
            }else{
                NSString *msg=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                [MBProgressHUD showError:msg];
                return ;
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
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
    [self.bt resignFirstResponder];
    [self.nr resignFirstResponder];
    
}


@end
