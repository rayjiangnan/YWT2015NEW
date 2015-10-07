//
//  personcenter.m
//  运维通
//
//  Created by abc on 15/8/8.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "personcenter.h"
#import "AFNetworkTool.h"
#import"MBProgressHUD+MJ.h"
#import "VPImageCropperViewController.h"
#import"MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UpFileSyn.h"
#import "PhotoPerson.h"

@interface personcenter ()<UIWebViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
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




@end

@implementation personcenter


-(void)viewDidAppear:(BOOL)animated{
    
    [self network];
    [self.view setNeedsDisplay];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *usertype = [userDefaultes stringForKey:@"usertype"];
    if ([usertype isEqualToString:@"40"]) {
       self.tabBarController.tabBar.hidden=YES;
    }else{
    
     self.tabBarController.tabBar.hidden=NO;
    }
   
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

-(void)network{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
        NSString *sty=[userDefaultes stringForKey:@"usertype"];
        if ([sty isEqualToString:@"10"]) {
            self.style.text=@"运维商";
        }else if([sty isEqualToString:@"20"]){
            self.style.text=@"运维人员";
        }else if([sty isEqualToString:@"30"]){
            self.style.text=@"调度";
        }else if([sty isEqualToString:@"40"]){
                self.style.text=@"运维人员";
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
