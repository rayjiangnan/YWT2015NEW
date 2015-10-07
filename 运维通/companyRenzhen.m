//
//  companyRenzhen.m
//  运维通
//
//  Created by 南江 on 15/9/11.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "companyRenzhen.h"
#import"AFNetworking.h"
#import"MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Extension.h"
#import "UpFileSyn.h"
#import "PhotoUpLoad.h"

@interface companyRenzhen ()
{
//    NSString *_accountType;
//    NSString *_name;
    NSString *FileType;
    MBProgressHUD *loading;
}


@property (weak, nonatomic) IBOutlet UITextField *companyName;

@property (weak, nonatomic) IBOutlet UITextField *personName;
@property (weak, nonatomic) IBOutlet UITextField *identityCard;

- (IBAction)didClickidentityCardAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *identityCardBut;
@property (weak, nonatomic) IBOutlet UIImageView *identyCardImageV;

- (IBAction)sfzbmClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSfzbm;
@property (weak, nonatomic) IBOutlet UIImageView *imgSfzbm;

- (IBAction)byzClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnByz;
@property (weak, nonatomic) IBOutlet UIImageView *imgByz;

@property (weak, nonatomic) IBOutlet UIButton *commitBut;
- (IBAction)didClickCommitButAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *yview;
@property (weak, nonatomic) IBOutlet UILabel *tishi;

@end

@implementation companyRenzhen
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self network];
    [self requestPic];
    
    [self tapBackground];
}

-(void)requestPic
{
    NSString *myString =[self GetUserID];
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getuserfile&q0=%@",urlt,myString];
    
    NSLog(@"%@",urlStr);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"ResultObject"]);
        
        NSMutableArray *arrray=responseObject[@"ResultObject"];
        if (![arrray isEqual:[NSNull null]]) {
            for (NSDictionary *str in arrray) {
                
                NSString *imgpath=[NSString stringWithFormat:@"%@%@",urlt,str[@"FileName"]];
 
                FileType=str[@"FileType"];
                [self ShowImg:imgpath showType:str[@"FileType"]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

-(void)network{
    
    NSString *myString =[self GetUserID];
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getauserbyid&q0=%@",urlt,myString];
    NSLog(@"%@",urlStr);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }else{
            NSDictionary *dictarr2=[json objectForKey:@"ResultObject"];
            int confirmState=[dictarr2[@"Certify"] intValue];
            
            self.companyName.text=[NSString stringWithFormat:@"%@", dictarr2[@"CertifyCompanyName"]];
            self.personName.text=[NSString stringWithFormat:@"%@", dictarr2[@"CertifyRealName"]];
            self.identityCard.text=[NSString stringWithFormat:@"%@", dictarr2[@"CertifyIDCard"]];
            
            //self.identityCard.text=dictarr2[@"CertifyRealName"];

              NSLog(@"%@",dictarr2[@"CertifyIDCard"]);
            
            if (confirmState==1 ||confirmState == 0) {
     
                self.tishi.text=@"请您提交真实有效的资料！";
                //self.tishi.hidden=YES;
                self.yview.hidden=NO;
                self.commitBut.hidden=NO;
                
            }
            else if (confirmState==2)
            {
                self.tishi.hidden=NO;
                self.yview.hidden=NO;
                
                self.tishi.text=@"审核状态:正在审核中，请耐心等候！";
                self.commitBut.hidden=YES;
                self.btnByz.hidden=YES;
                self.btnSfzbm.hidden=YES;
                self.identityCard.hidden=YES;
            }
            else if (confirmState==10)
            {
                self.tishi.hidden=NO;
                self.yview.hidden=NO;
              
                self.tishi.text=@"审核状态:认证失败，请重新提交资料！";
                self.commitBut.hidden=NO;
            }
            
           if (confirmState==2 || confirmState==99)
            {
                self.identityCardBut.hidden=YES;
                self.commitBut.hidden=YES;
                self.btnByz.hidden=YES;
                self.btnSfzbm.hidden=YES;
                
                
                self.personName.userInteractionEnabled=NO;
                self.identityCard.userInteractionEnabled=NO;
            }
        }
        
        //NSLog(@"公司的名称是 ======%@",_name);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sfzbmClick:(id)sender {
    FileType=@"e_fr_sfzfm";
    [self SelectImg];
}

- (IBAction)byzClick:(id)sender {
    FileType=@"e_ylzz";
    [self SelectImg];
}

- (IBAction)didClickidentityCardAction:(id)sender {
    FileType=@"e_fr_sfzzm";
    [self SelectImg];
}

-(void) ShowImg:(NSString *) imgpath showType:(NSString *) mType
{
    NSURL *imgurl=[NSURL URLWithString:imgpath];
    //UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
    if ([mType isEqualToString:@"e_fr_sfzzm"]) {
        //self.identyCardImageV.image=imgstr;
        [self.identyCardImageV setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:imgpath]];
    }
    else  if ([mType isEqualToString:@"e_fr_sfzfm"]) {
        //self.imgSfzbm.image=imgstr;
        [self.imgSfzbm setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:imgpath]];
    }
    else  if ([mType isEqualToString:@"e_ylzz"]) {
        //self.imgByz.image=imgstr;
        [self.imgByz setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:imgpath]];
    }
}

- (IBAction)didClickCommitButAction:(id)sender {
    
    NSString *myString =[self GetUserID];
    
    NSString *strurl=[NSString stringWithFormat:@"%@/API/YWT_User.ashx",urlt];
    NSString *str = [NSString stringWithFormat:@"action=userfilecertify&q0=%@&q1=%@&q2=%@&q3=%@&q4=%@",myString,@"E",self.personName.text, self.identityCard.text,self.companyName.text];
    NSLog(@"%@ %@",strurl,str);
    AFHTTPRequestOperation *op=[self POSTurlString:strurl parameters:str];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"提交成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"数据请求出错"];
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        portraitImg=[self fixOrientation:portraitImg];
   
        loading= [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:loading];
        [loading show:YES];
        [self UpdateFileImage:portraitImg];
    }];
}


- (void) UpdateFileImage:(UIImage *)currentImage
{
    NSData *data = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSString *userid =[self GetUserID];
    NSString *url=[NSString stringWithFormat:@"%@/API/YWT_UPUserFile.ashx?action=%@&q0=%@&q1=%@&from=ios",urlt,FileType,userid,userid];
    
    UpFileSyn *_upfile=[UpFileSyn alloc];
    [_upfile UpFile:data UpURL:url Success:^(NSDictionary *result) {
        NSString *Status=[NSString stringWithFormat:@"%@",result[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            [loading hide:YES];
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",result[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
        }
        else
        {
            [loading hide:YES];
            NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,result[@"ReturnMsg"]];
            [self ShowImg:img showType:FileType];
        }
        [loading hide:YES];
    } Failure:^(NSError *error) {
        NSLog(@"出错啦：%@",error);
        [loading hide:YES];
    }];
}

-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}
-(void)tapOnce
{
    [self.companyName resignFirstResponder];
    [self.personName resignFirstResponder];
    [self.identityCard resignFirstResponder];
}

@end
