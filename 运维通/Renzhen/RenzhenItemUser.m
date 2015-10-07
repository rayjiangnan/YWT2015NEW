//
//  RenzhenItemUser.m
//  运维通
//
//  Created by ritacc on 15/10/5.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "RenzhenItemUser.h"

#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "UIImageView+WebCache.h"


@interface RenzhenItemUser ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UILabel *CertifyRealName;
@property (weak, nonatomic) IBOutlet UILabel *CertifyIDCard;


@property (weak, nonatomic) IBOutlet UIImageView *p_sfzzm;
@property (weak, nonatomic) IBOutlet UIImageView *p_sfzbm;
@property (weak, nonatomic) IBOutlet UIImageView *p_byz;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sgStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtResult;

@property (nonatomic,strong)NSString *tempid;
- (IBAction)btnSaveClick:(id)sender;

@end

@implementation RenzhenItemUser

@synthesize UserID;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadItem];
    self.tempid=UserID;
    
    self.scrollview.contentSize=CGSizeMake(320, 700);
    
    [self tapBackground];
    [self tapOnce];
    
    [self ChangeItemInit:@"Renzhen"];
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    
}

-(void) LoadItem
{
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_CertifyApproval.ashx?action=getitem&q0=%@",urlt,UserID];
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json=responseObject;
        NSLog(@"%@",json);
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
        }else{
            NSDictionary *dict2=json[@"ResultObject"];
            self.CertifyRealName.text= [NSString stringWithFormat:@"%@",dict2[@"CertifyRealName"]];
            self.CertifyIDCard.text= [NSString stringWithFormat:@"%@",dict2[@"CertifyIDCard"]];
            
            NSMutableArray *arrray=dict2[@"listFiles"];
            if (![arrray isEqual:[NSNull null]]) {
                for (NSDictionary *str in arrray) {
                    NSString *imgpath=[NSString stringWithFormat:@"%@%@",urlt,str[@"FileName"]];
                    
                    [self ShowImg:imgpath showType:str[@"FileType"]];
                }
            }
        }
        NSLog(@"加载数据完成。");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}
-(void) ShowImg:(NSString *) imgpath showType:(NSString *) mType
{
    NSURL *imgurl=[NSURL URLWithString:imgpath];
    if ([mType isEqualToString:@"p_sfzzm"]) {
        [self.p_sfzzm setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:imgpath]];
    }
    else  if ([mType isEqualToString:@"p_sfzbm"]) {
        [self.p_sfzbm setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:imgpath]];
    }
    else  if ([mType isEqualToString:@"p_byz"]) {
        [self.p_byz setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:imgpath]];
    }
}

- (IBAction)btnSaveClick:(id)sender {
    
    NSInteger indexseg= self.sgStatus.selectedSegmentIndex;
    int istatus=99;
    if (indexseg!=0) {
        istatus=10;//拒绝
    }
    NSString *strResult=[NSString stringWithFormat:@"%@",self.txtResult.text];
    if(istatus== 10 && [self isBlankString:strResult] == YES)
    {
        [MBProgressHUD showError:@"请输入审核意见！"];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_CertifyApproval.ashx",urlt];
    NSString *strparameters=[NSString stringWithFormat:@"action=save&q0=%@&q1=%d&q2=%@"
                             ,self.tempid,istatus,strResult];
    NSLog(@"%@",urlStr);
    NSLog(@"%@",strparameters);
    AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:strparameters];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
            return ;
        }else{
            [self ChangeRecord: self.tempid key:@"Renzhen"];
            [MBProgressHUD showSuccess:@"保存成功！"];
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
    [self.txtResult resignFirstResponder];
    
}


@end
