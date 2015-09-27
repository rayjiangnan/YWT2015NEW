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
#import "UpFile.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Extension.h"

@interface companyRenzhen ()
{
    NSString *_accountType;
    NSString *_name;
    NSString *FileType;
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
        }else{
            return ;
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
        NSMutableDictionary *dict=responseObject;
        NSDictionary *dictarr2=[dict objectForKey:@"ResultObject"];
        
        _name=dictarr2[@"SupplierID_Name"];
        _accountType=[NSString stringWithFormat:@"%@",dictarr2[@"UserType"]];
        NSString *confirmState=[NSString   stringWithFormat:@"%@", dictarr2[@"Certify"]];
        if (![dictarr2[@"RealName"] isEqual:[NSNull null]]) {
            self.personName.text=[NSString stringWithFormat:@"%@", dictarr2[@"RealName"]];
        }
        
        if (![dictarr2[@"CertifyIDCard"] isEqual:[NSNull null]]) {
            self.identityCard.text=[NSString   stringWithFormat:@"%@", dictarr2[@"CertifyIDCard"]];
        }
        
        if ([confirmState isEqual:[NSNull null]]||[confirmState isEqualToString:@"1"]||[confirmState isEqualToString:@"0"]) {
 
            self.tishi.text=@"审核状态:未提交审核请您提交真实有效的资料！";
            self.yview.hidden=NO;
            self.commitBut.hidden=NO;
            
        }
        else if ([confirmState isEqualToString:@"2"])
        {
            
 
            
            self.tishi.hidden=NO;
            self.yview.hidden=NO;
            
            self.tishi.text=@"审核状态:正在审核中，请耐心等候！";
            self.commitBut.hidden=YES;
            self.btnByz.hidden=YES;
            self.btnSfzbm.hidden=YES;
            self.identityCard.hidden=YES;
            
            
            
        }else if ([confirmState isEqualToString:@"10"]){
            self.tishi.hidden=NO;
            self.yview.hidden=NO;
          
            self.tishi.text=@"审核状态:认证失败，请重新提交资料！";            self.commitBut.hidden=NO;
            
        }
        
        
        if ([confirmState isEqualToString:@"2"] ||[confirmState isEqualToString:@"99"])
        {
            self.identityCardBut.hidden=YES;
            self.commitBut.hidden=YES;
            self.btnByz.hidden=YES;
            self.btnSfzbm.hidden=YES;
            
            
            self.personName.userInteractionEnabled=NO;
            self.identityCard.userInteractionEnabled=NO;
        }
        

        
             
        
        NSLog(@"公司的名称是 ======%@",_name);
        
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
    [self SendImage];
}

- (IBAction)byzClick:(id)sender {
    FileType=@"e_ylzz";
    [self SendImage];
}

- (IBAction)didClickidentityCardAction:(id)sender {
    FileType=@"e_fr_sfzzm";
    [self SendImage];
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

- (void) SendImage
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    sheet=[[UIActionSheet alloc] initWithTitle:@"选择"
                                      delegate:self
                             cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                             otherButtonTitles:@"拍照", @"从相册中选取", nil];
    sheet.tag = 255;
    [sheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UpFile *_upfile=[[UpFile alloc]init];
        portraitImg=[_upfile fixOrientation:portraitImg];
        //_receiveImage=portraitImg;
        [self UpdateFileImage:portraitImg];
    }];
}


- (void) UpdateFileImage:(UIImage *)currentImage
{
    NSData *data = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSString *hyphens = @"--";
    NSString *boundary = @"*****";
    NSString *end = @"\r\n";
    NSMutableData *myRequestData1=[NSMutableData data];
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableString *fileTitle=[[NSMutableString alloc]init];
    
    
    [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"file%d",1],[NSString stringWithFormat:@"image%d.png",1]];
    
    [fileTitle appendString:end];
    
    [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
    [fileTitle appendString:end];
    
    [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData1 appendData:data];
    
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *userid =[self GetUserID];
    //NSString *url=[NSString stringWithFormat:@"%@/API/YWT_OrderFile.ashx?action=90",strUploadUrl];
    NSString *url=[NSString stringWithFormat:@"%@/API/YWT_UPUserFile.ashx?action=%@&q0=%@&q1=%@&from=ios",urlt,FileType,userid,userid];
    
    
    
    // NSLog(@"%@",url);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    
    
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    
    NSString *Status=[NSString stringWithFormat:@"%@",dict[@"Status"]];
    if ([Status isEqualToString:@"0"]){
        NSString *ReturnMsg=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
        [MBProgressHUD showError:ReturnMsg];
        NSLog(@"%@",ReturnMsg);
    }
    else
    {
        NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,dict[@"ReturnMsg"]];
        [self ShowImg:img showType:FileType];
    }
}


@end
