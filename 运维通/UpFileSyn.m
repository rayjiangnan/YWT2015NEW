//
//  UpFileSyn.m
//  运维通
//
//  Created by ritacc on 15/10/3.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "UpFileSyn.h"

@implementation UpFileSyn

-(void) UpFile:(NSData *) filedata UpURL:(NSString *) _upURL
       Success:(void (^)(NSDictionary *result))success
       Failure:(void (^)(NSError *error))failure
{
    
    Success=success;
    
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
    
    [myRequestData1 appendData:filedata];
    
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSString *url=[NSString stringWithFormat:@"%@/API/YWT_OrderFile.ashx?action=30",strUploadUrl];
    //根据url初始化request
    
    // NSLog(@"%@",url);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_upURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //NSHTTPURLResponse *urlResponese = nil;
    //NSError *error = [[NSError alloc]init];
    
    NSURLConnection * result=  [[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSLog(@"result=====%@",result);
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection %@",data);
    
    NSString * result= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if (data!=nil) {
        if (Success) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            Success(dict);
    }
    else
    {
        Failure(nil);
    }
//        [result dataUsingEncoding:NSUTF8StringEncoding];
        
//        NSLog(@"结果：%@",dict);
//        NSLog(@"结果：%@",dict[@"ReturnMsg"]);
//        NSLog(@"结果：%@",dict[@"ReturnMsgIcon"]);
    }
    //[loading hide:YES];
    //[self.receiveData appendData:data];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection connection");
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    if (Failure) {
        Failure(error);
    }
}
//接收到服务器回应的时候调用此方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"connection didReceiveResponse");
}
@end
