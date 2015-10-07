////
////  icon.m
////  运维通
////
////  Created by ritacc on 15/7/17.
////  Copyright (c) 2015年 ritacc. All rights reserved.
////
//
//#import "icon.h"
//#import"MBProgressHUD+MJ.h"
//
//@interface icon ()
//@property(nonatomic,copy)NSDictionary *result;
//@property (nonatomic,strong)NSString *idtt2;
//
//@end
//
//@implementation icon
//@synthesize strTtile;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    NSString *idtt2=[NSString stringWithFormat:@"%@",strTtile];
//    [self idt2:idtt2];
//    //[self net];
//    
//    
//}
//
//-(NSString *)idt2:(NSString *)id2{
//    _idtt2=id2;
//    return _idtt2 ;
//}
//
//
//
//- (IBAction)reg {
//    
//    [self btnupload_Click:nil];
//    NSLog(@"ok");
//    [[self navigationController] popViewControllerAnimated:YES];
//}
//
//
// 
//
//- (IBAction)selectImg_Click:(id)sender {
//    
//    UIActionSheet *sheet;
// 
//        sheet=[[UIActionSheet alloc] initWithTitle:@"选择"
//                                          delegate:self
//                                 cancelButtonTitle:nil
//                            destructiveButtonTitle:@"取消"
//                                 otherButtonTitles:@"拍照",@"从相册择", nil];
// 
//    sheet.tag = 255;
//    [sheet showInView:self.view];
//}
//
//- (void)btnupload_Click:(id)sender {
//    NSString *myString =[self GetUserID];
//    
//    [self UpdateFileImage:self.imageView.image  action:@"userimg" orderid:myString creatorid:myString uploadUrl:urlt];
//    
//    NSLog(@"完成上传图片。");
//}
//
//-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag == 255) {
//        
//        NSUInteger sourceType = 0;
//        // 判断是否支持相机
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            
//            switch (buttonIndex) {
//                case 0:
//                    // 取消
//                    return;
//                case 1:
//                    // 相机
//                    sourceType = UIImagePickerControllerSourceTypeCamera;
//                    break;
//                case 2:
//                    // 相册
//                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    break;
//            }
//        }
//        else {
//            if (buttonIndex == 0) {
//                return;
//            } else {
//                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            }
//        }
//        // 跳转到相机或相册页面
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate=self;
//        imagePickerController.allowsEditing = YES;
//        imagePickerController.sourceType = sourceType;
//        [self presentViewController:imagePickerController animated:YES completion:^{}];
//        //[imagePickerController release];
//    }
//}
//
//#pragma mark - image picker delegte
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:^{}];
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    [self.imageView setImage:image];
//    self.imageView.tag = 100;
//    NSLog(@"setImage:savedImage");
//    
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:^{}];
//}
//
//#pragma mark - 保存图片至沙盒
//- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
//{
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//    // 获取沙盒目录
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    // 将图片写入文件
//    [imageData writeToFile:fullPath atomically:NO];
//    NSLog(@"保存图片至泥沙盒");
//
//
//}
//
//- (NSDictionary *) UpdateFileImage:(UIImage *)currentImage
//                            action:(NSString *) straction
//                           orderid:(NSString *) strOrderid
//                         creatorid:(NSString *) strCreatorid //创建人ID
//                         uploadUrl:(NSString *) strUploadUrl //上传路径
//{
//    NSData *data = UIImageJPEGRepresentation(currentImage, 0.5);
//    
//    NSString *hyphens = @"--";
//    NSString *boundary = @"*****";
//    NSString *end = @"\r\n";
//    NSMutableData *myRequestData1=[NSMutableData data];
//    
//    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSMutableString *fileTitle=[[NSMutableString alloc]init];
//    
//    [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"file%d",1],[NSString stringWithFormat:@"image%d.png",1]];
//    
//    [fileTitle appendString:end];
//    
//    [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
//    [fileTitle appendString:end];
//    
//    [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [myRequestData1 appendData:data];
//    
//    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSString *url=[NSString stringWithFormat:@"%@/API/YWT_UPUserFile.ashx?from=ios&action=%@&q0=%@&q1=%@"
//                   ,strUploadUrl,straction,strOrderid,strCreatorid];
//    //根据url初始化request
//    
//    // NSLog(@"%@",url);
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                       timeoutInterval:5];
//    
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    //设置HTTPHeader
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
//    //设置http body
//    [request setHTTPBody:myRequestData1];
//    //http method
//    [request setHTTPMethod:@"POST"];
//    
//    
//    
//    NSHTTPURLResponse *urlResponese = nil;
//    NSError *error = [[NSError alloc]init];
//    
//    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
//    //  NSDictionary * result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
//    
//    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
//    
//    NSData *data5 = [result dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data5 options:NSJSONReadingMutableLeaves error:nil];
//    _result=dict;
// NSLog(@"返回结果=====%@,",_result);
//    return _result;
//}
//
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //  isFullScreen = !isFullScreen;
//    
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint touchPoint = [touch locationInView:self.view];
//    CGPoint imagePoint = self.imageView.frame.origin;
//    //touchPoint.x ，touchPoint.y 就是触点的坐标
//    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
//    
//    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <= touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
//    {
//        // 设置图片放大动画
//        [UIView beginAnimations:nil context:nil];
//        // 动画时间
//        [UIView setAnimationDuration:1];
//        /*
//         if (isFullScreen) {
//         // 放大尺寸
//         
//         self.imageView.frame = CGRectMake(0, 0, 320, 480);
//         }
//         else {
//         // 缩小尺寸
//         self.imageView.frame = CGRectMake(50, 65, 90, 115);
//         }
//         */
//        // commit动画
//        [UIView commitAnimations];
//    }
//    
//}
//@end
