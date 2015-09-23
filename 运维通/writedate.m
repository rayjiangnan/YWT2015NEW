//
//  writedate.m
//  运维通
//
//  Created by abc on 15/8/3.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "writedate.h"
#import "MBProgressHUD+MJ.h"
#import "SBJson.h"

@interface writedate ()
@property (weak, nonatomic) IBOutlet UITextField *bt;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation writedate



-(void)viewDidAppear:(BOOL)animated{
    [self ChangeItemInit:@"log"];
    self.tabBarController.tabBar.hidden=YES;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapBackground];
    [self tapOnce];
      self.scrollview.contentSize=CGSizeMake(320, 800);
}

- (IBAction)save:(id)sender {

    
    [self postJSON :@"0"];
}

- (IBAction)post:(id)sender {
    
    [self postJSON:@"1"];
}

- (void)postJSON:(NSString *)LogStatus

{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@/API/YWT_YWLog.ashx",urlt];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:myString forKey:@"UserID"];
    [dic setValue:self.bt.text forKey:@"Title"];
    [dic setValue:self.content.text forKey:@"Content"];
    [dic setValue:LogStatus forKey:@"LogStatus"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    

    NSString *str = [NSString stringWithFormat:@"action=addedit&q0=%@&q1=%@",jsonString,@""];
    
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
    [self.content resignFirstResponder];

}

@end
