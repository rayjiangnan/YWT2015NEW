//
//  beginorder.m
//  运维通
//
//  Created by ritacc on 15/7/22.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "beginorder.h"
#import "MBProgressHUD+MJ.h"
#import "finishion.h"
#import "VPImageCropperViewController.h"
#import"MBProgressHUD.h"
#import "UIViewController+Extension.h"
#import "UpFileSyn.h"
#import "PhotoUpLoad.h"

@interface beginorder ()<UIWebViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    
    NSString *_accountType;
    UIImage *_receiveImage;
    MBProgressHUD *HUD;
    MBProgressHUD *loading;
    int btnnum;
}

@property (weak, nonatomic) IBOutlet UILabel *danhao;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *style;

@property (weak, nonatomic) IBOutlet UILabel *dri;

@property (weak, nonatomic) IBOutlet UILabel *bt;
@property (nonatomic,strong)NSString *idtt;

//@property (weak, nonatomic) IBOutlet UILabel *beiz;

//@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *xj1;
@property (weak, nonatomic) IBOutlet UIButton *xj2;
@property (weak, nonatomic) IBOutlet UIButton *xj3;
@property (weak, nonatomic) IBOutlet UIButton *xj4;


@property (nonatomic,strong)NSString *img1;
@property (nonatomic,strong)NSString *img2;
@property (nonatomic,strong)NSString *img3;
@property (nonatomic,strong)NSString *img4;

@property (nonatomic,strong)NSString *img1icon;
@property (nonatomic,strong)NSString *img2icon;
@property (nonatomic,strong)NSString *img3icon;
@property (nonatomic,strong)NSString *img4icon;

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation beginorder
@synthesize strTtile;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestaaa];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg=[self fixOrientation:portraitImg];
        _receiveImage=portraitImg;
        
        [self btnupload_Click:nil];
    }];
}

- (void)btnupload_Click:(id)sender {
    
    loading= [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:loading];
    [loading show:YES];

    
    [self UpdateFileImage:_receiveImage];
    
     NSLog(@"完成上传图片。");
}

- (void) UpdateFileImage:(UIImage *)currentImage
{
    NSData *data = UIImageJPEGRepresentation(currentImage, 0.4);
    NSString *url=[NSString stringWithFormat:@"%@/API/YWT_OrderFile.ashx?action=30",urlt];
    //根据url初始化request
    
    UpFileSyn *_upfile=[UpFileSyn alloc];
    [_upfile UpFile:data UpURL:url Success:^(NSDictionary *result) {
        if (result!=nil)
        {
            NSString *Status=[NSString stringWithFormat:@"%@",result[@"Status"]];
            if ([Status isEqualToString:@"0"]){
                
                NSString *ReturnMsg=[NSString stringWithFormat:@"%@",result[@"ReturnMsg"]];
                [MBProgressHUD showError:ReturnMsg];
                NSLog(@"%@",ReturnMsg);
            }
            else
            {
                [self SetImg:result[@"ReturnMsg"] IconPath:result[@"ReturnMsgIcon"]];
            }
            [loading hide:YES];
        }
    } Failure:^(NSError *error) {
        NSLog(@"出错啦：%@",error);
        [loading hide:YES];
    }];
}

-(void) SetImg :(NSString *) imgPath IconPath:(NSString *) _iconpath
{
    NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,_iconpath];
    NSURL *imgurl=[NSURL URLWithString:img];
    
    if (btnnum==1) {
        _img1=imgPath;
        _img1icon=_iconpath;
        UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [self.xj1 setBackgroundImage:imgstr forState:UIControlStateNormal];
    }
    else if (btnnum==2) {
        _img2=imgPath;
        _img2icon=_iconpath;
        UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [self.xj2 setBackgroundImage:imgstr forState:UIControlStateNormal];
    }
    else if (btnnum==3) {
        _img3=imgPath;
        _img3icon=_iconpath;
        UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [self.xj3 setBackgroundImage:imgstr forState:UIControlStateNormal];
    }
    else if (btnnum==4) {
        _img4=imgPath;
        _img4icon=_iconpath;
        UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [self.xj4 setBackgroundImage:imgstr forState:UIControlStateNormal];
    }
}


-(void)requestaaa
{
    NSString *Create_User = [self GetUserID];
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=getitem&q0=%@&q1=%@",urlt,mystring2,Create_User];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    NSLog(@"%@",urlStr);
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }
        NSDictionary *dict=json[@"ResultObject"];
        if (![dict[@"OrderUsers"] isEqual:[NSNull null]]) {
            NSArray *dict3=dict[@"OrderUsers"];
            if (dict3.count>0) {
                NSDictionary *dic=[dict3 objectAtIndex:0];
                if (![dic[@"RealName"] isEqual:[NSNull null]]) {
                    NSString *dr=[NSString stringWithFormat:@"%@  %@",dic[@"RealName"],dic[@"Mobile"]];
                    self.dri.text=dr;
                }
            }
        }
        self.danhao.text=dict[@"OrderNo"];
        self.time.text=[self DateFormartYMD:dict[@"CreateDateTime"]];
        [self idt:dict[@"Order_ID"]];
        
        self.style.text=dict[@"Status_Name"];
        self.bt.text=dict[@"OrderTitle"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
}
- (IBAction)post:(id)sender {
    [self tijiao2 ];//:lat :longti :@"西乡" :self.beiz.text :@""];
}
-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}

-(void)tijiao2//:(NSString *)t1:(NSString *)t2:(NSString *)t3:(NSString *)t4:(NSString *)t5
{
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/API/YWT_Order.ashx",urlt] ;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
    
    request.HTTPMethod = @"POST";
    NSString *Create_User = [self GetUserID];
    
    NSString *dest=[NSString stringWithFormat:@"[{\"FileName\":\"%@\",\"FileIcon\":\"%@\"},{\"FileName\":\"%@\",\"FileIcon\":\"%@\"},{\"FileName\":\"%@\",\"FileIcon\":\"%@\"},{\"FileName\":\"%@\",\"FileIcon\":\"%@\"}]",_img1,_img1icon,_img2,_img2icon,_img3,_img3icon,_img4,_img4icon];
    
    NSString *str = [NSString stringWithFormat:@"action=saveorderflow&q0=%@&q1=30&q2=%@&q3=%@&q4=%@&q5=%@&q6=%@&q7=%@",_idtt,Create_User,@"",@"",@"",@"",dest];
    
    NSLog(@"%@?%@",urlt,str);
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
        if (data!=nil) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];
                
                if ([errstr2 isEqualToString:@"0"]){
                    NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                    
                    [MBProgressHUD showError:str];
                    return ;
                }else{
                    [self ChangeRecord:_idtt key:@"Order"]; //处理刷新问题
                    [MBProgressHUD showSuccess:@"提交成功"];
                    [[self navigationController] popViewControllerAnimated:YES];
                }
                
            }];
            
        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD showError:@"网络异常请检查！"];
                return ;
            }];
        }
    }];
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    [self requestaaa];
//    id vc=segue.destinationViewController;
//    if ([vc isKindOfClass:[finishion class]]) {
//        finishion *detai=vc;
//        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
//        [detai setValue:mystring2 forKey:@"strTtile"];
//        
//    }
//}


- (IBAction)postimg1:(id)sender {
    btnnum=1;
    [self SelectImg];
}
- (IBAction)postimg2:(id)sender {
    btnnum=2;
    [self SelectImg];
}
- (IBAction)postimg3:(id)sender {
    btnnum=3;
    [self SelectImg];
}
- (IBAction)postimg4:(id)sender {
    btnnum=4;
    [self SelectImg];
}



@end
