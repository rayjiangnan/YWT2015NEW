//
//  center.m
//  运维通
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "center.h"
#import "AFNetworkTool.h"
#import"MBProgressHUD+MJ.h"
#import "VPImageCropperViewController.h"
#import"MBProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIViewController+Extension.h"
#import "UpFileSyn.h"
#import "PhotoPerson.h"

@interface center ()<UIWebViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate
,UIImagePickerControllerDelegate,UINavigationControllerDelegate, VPImageCropperDelegate>
{

    NSString *_accountType;
    UIImage *_receiveImage;
    MBProgressHUD *HUD;
    MBProgressHUD *loading;
}

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *style;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UIButton *img;
@property (weak, nonatomic) IBOutlet UIButton *gerenbtn;
@property (weak, nonatomic) IBOutlet UIButton *combtn;
@property (weak, nonatomic) IBOutlet UIButton *renz;


@end

@implementation center


-(void)viewDidAppear:(BOOL)animated{
    [self.view setNeedsDisplay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [AFNetworkTool netWorkStatus];


    
    UIColor *myColorRGB =[self GetUIColor];
    
    self.navigationController.navigationBar.barTintColor=myColorRGB;

    [self.navigationController.navigationBar setTitleTextAttributes:

    @{NSFontAttributeName:[UIFont systemFontOfSize:17],

    NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.img.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectImg)];
    [self.img addGestureRecognizer:tap];
    
    //显示信息
    [self network];
}
-(void)network{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    //认证
    NSString *Certify = [userDefaultes stringForKey:@"Certify"];
    if ([Certify isEqualToString:@"99"]) {
        [self.renz setTitle:@"已认证" forState:UIControlStateNormal];
    }else if ([Certify isEqualToString:@"2"]) {
        [self.renz setTitle:@"审核中" forState:UIControlStateNormal];
    }else if ([Certify isEqualToString:@"10"]) {
        [self.renz setTitle:@"认证失败" forState:UIControlStateNormal];
    }
    else
    {
        [self.renz setTitle:@"未认证" forState:UIControlStateNormal];
    }
    
    
    NSString *usertype=[userDefaultes stringForKey:@"usertype"];
    if ([usertype isEqualToString:@"10"]) {
        self.style.text=@"运维商";
    }else if([usertype isEqualToString:@"20"]){
        self.style.text=@"运维人员";
    }else if([usertype isEqualToString:@"30"]){
        self.style.text=@"调度";}
    else if([usertype isEqualToString:@"40"]){
        self.style.text=@"运维人员";
    }
    if ([usertype isEqualToString:@"10"]) {
        self.gerenbtn.hidden=NO;
    }
    
    self.tel.text=[userDefaultes stringForKey:@"Mobile"];
    self.username.text=[userDefaultes stringForKey:@"RealName"];
    NSString *strUserimg=[userDefaultes stringForKey:@"UserImg"];
    if ([[NSString stringWithFormat:@"%@",strUserimg] isEqualToString:@"/Images/defaultPhoto.png"]) {
        return;
    }else{
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,strUserimg];
        NSURL *imgurl=[NSURL URLWithString:img];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        UIImage *cachedImage = [manager imageWithURL:imgurl];
        if (cachedImage)
        {
            [self.img setBackgroundImage:cachedImage forState:UIControlStateNormal];
        }
        else
        {
            [manager downloadWithURL:imgurl delegate:nil];
            UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
            [self.img setBackgroundImage:imgstr forState:UIControlStateNormal];
        }
    }
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
    [editedImage drawInRect:CGRectMake(0, 0, 300, 300)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"++++++++++++++++++++++%@",reSizeImage);
    
    _receiveImage=reSizeImage;
    
    [self btnupload_Click:nil];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
}



- (void)btnupload_Click:(id)sender {
    loading = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:loading];
    [loading show:YES];
    [self UpdateFileImage];    //:_receiveImage action:@"" orderid:myString creatorid:myString uploadUrl:urlt];
    
    NSLog(@"完成上传图片。");
}


- (void) UpdateFileImage
{
    NSData *data = UIImageJPEGRepresentation(_receiveImage, 0.5);
    NSString *UserID =[self GetUserID];
    NSString *url=[NSString stringWithFormat:@"%@/API/YWT_UPUserFile.ashx?from=ios&action=userimg&q0=%@&q1=%@",urlt,UserID,UserID];
    UpFileSyn *_upfile=[UpFileSyn alloc];
    [_upfile UpFile:data UpURL:url Success:^(NSDictionary *result) {
        if (result!=nil)
        {
            NSString *Status=[NSString stringWithFormat:@"%@",result[@"Status"]];
            if ([Status isEqualToString:@"0"]){
                [loading hide:YES];
                NSString *ReturnMsg=[NSString stringWithFormat:@"%@",result[@"ReturnMsg"]];
                [MBProgressHUD showError:ReturnMsg];
                NSLog(@"%@",ReturnMsg);
            }
            else
            {
                
                NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,result[@"ReturnMsg"]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:result[@"ReturnMsg"] forKey:@"UserImg"];
                
                NSURL *imgurl=[NSURL URLWithString:img];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadWithURL:imgurl delegate:nil];
                UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
                [loading hide:YES];
                [self.img setBackgroundImage:imgstr forState:UIControlStateNormal];
            }
            [loading hide:YES];
        }
    } Failure:^(NSError *error) {
        NSLog(@"出错啦：%@",error);
        [loading hide:YES];
    }];
}


- (IBAction)exit:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"您确定注销登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"确定"];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        return;
        
    }else if(buttonIndex == 1){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *g2=@"";
        
        [userDefaults setObject:g2 forKey:@"autopass"];
        [userDefaults setObject:g2 forKey:@"myidt"];
        [self performSegueWithIdentifier:@"fanhui" sender:nil];
        
    }}

@end
