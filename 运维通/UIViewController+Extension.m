//
//  UIViewController+Extension.m
//  送哪儿
//
//  Created by pan on 15/7/13.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

#pragma mark 封装get请求
-(AFHTTPRequestOperation *)GETurlString:(NSString *)urlString {
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    return op;
}

#pragma mark 封装post请求
-(AFHTTPRequestOperation *)POSTurlString:(NSString *)urlString parameters:(NSString *)parameters{
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    request.timeoutInterval=60;
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    return op;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(NSString*) DateFormartString:(NSString*) sourcedate
{
    NSString *dt3=sourcedate;
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [objDateformat3 stringFromDate: date3];
}
-(NSString*) DateFormartMDHM:(NSString*) sourcedate
{
    NSString *dt3=sourcedate;
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"MM-dd HH:mm"];
    return [objDateformat3 stringFromDate: date3];
}

-(NSString*) DateFormartYMD:(NSString*) sourcedate
{
    NSString *dt3=sourcedate;
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"yyyy-MM-dd"];
    return [objDateformat3 stringFromDate: date3];
}

-(NSString*) DateFormartMD:(NSString*) sourcedate
{
    NSString *dt3=sourcedate;
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"MM-dd"];
    return [objDateformat3 stringFromDate: date3];
}

#pragma  分页刷新处理。
-(int) ChangePageInit:(NSString *) CKey
{
    NSLog(@"%@",@"ChangePageInit");
    NSUserDefaults *defau=[NSUserDefaults standardUserDefaults];
    int v=[defau integerForKey:[NSString stringWithFormat:@"changeKey%@",CKey]];
    if (!v) {
        v=1;
    }
         //还原状态
    [defau setInteger:1 forKey:[NSString stringWithFormat:@"changeKey%@",CKey]];
    return  v ;
}

-(void)  ChangeItemInit:(NSString *) CKey
{
    NSLog(@"%@",@"ChangeItemInit");
    NSUserDefaults *defau=[NSUserDefaults standardUserDefaults];
    int i= [defau integerForKey:[NSString stringWithFormat:@"changeKey%@",CKey]];
    if (i!= 3) {
        [defau setInteger:2 forKey:[NSString stringWithFormat:@"changeKey%@",CKey]];
    }
}

-(void)  ChangeRecord:(NSString *) chageID key:(NSString *) CKey
{
    NSLog(@"%@%@",@"ChageRecord",CKey);
    
    NSUserDefaults *defau=[NSUserDefaults standardUserDefaults];
    [defau setInteger:3 forKey:[NSString stringWithFormat:@"changeKey%@",CKey]];
    [defau setObject:chageID forKey:[NSString stringWithFormat:@"changeKeyID%@",CKey]];
}

//获取修改页数
-(int) ChangeNnm:(NSMutableArray *) Records ItemIDKey:(NSString *) _idkey ID:(NSString *) _id
{
    int chagePage=0;
    int PageCount=Records.count;
    int Index=-1;
    for(int i=0;i< PageCount;i++)
    {
        NSDictionary *dictarr=[Records objectAtIndex:i];
       
        NSString *strid=[NSString stringWithFormat:@"%@",dictarr[_idkey]];
        if ([strid isEqualToString: _id]) {
            Index=i;
            break;
        }
    }
    if (Index>=0) {
        if (Index<10) {
            chagePage=0;
        }
        else
        {
            int tNum=Index/ 10;
            if (tNum * 10 != Index) {
                tNum++;
            }
            chagePage=tNum;
        }
    }
    
    return chagePage;
}
//替换集合中的数据
-(BOOL) ChangeData:(NSMutableArray *) CRecord NewLoadRecords: (NSMutableArray *) _NewLoadRecords   ItemIDKey:(NSString *) _idkey ID:(NSString *) _id
{
    if (CRecord == nil || _NewLoadRecords == nil) {
        return  FALSE;
    }
    int PC=CRecord.count;
    int Index=-1;
    for(int i=0;i< PC;i++)
    {
        NSDictionary *dictarr=[CRecord objectAtIndex:i];
        NSString *strid=[NSString stringWithFormat:@"%@",dictarr[_idkey]];
        if ([strid isEqualToString: _id]) {
            Index=i;
            break;
        }
    }
    int IndexN=-1;
    if (Index>=0) {
        for(int i=0;i< _NewLoadRecords.count;i++)
        {
            NSDictionary *dictarr=[CRecord objectAtIndex:i];
            NSString *strid=[NSString stringWithFormat:@"%@",dictarr[_idkey]];
            if ([strid isEqualToString: _id]) {
                IndexN=i;
                break;
            }
        }
    }
    if (IndexN==-1) {
        return  FALSE;
    }
    //替换集合
    CRecord[Index]=_NewLoadRecords[IndexN];
    return TRUE;
}

-(NSString *)  ChangeGetChageID :(NSString *) CKey
{
    NSLog(@"%@",@"ChangeGetChageID");
    NSUserDefaults *defau=[NSUserDefaults standardUserDefaults];

    NSString *strid= [defau stringForKey:[NSString stringWithFormat:@"changeKeyID%@",CKey]];
    return strid;
}


-(void)  ChangeRecordAdd :(NSString *) CKey
{
    NSLog(@"%@",@"ChageRecordAdd");
    NSUserDefaults *defau=[NSUserDefaults standardUserDefaults];
    [defau setInteger:4 forKey:[NSString stringWithFormat:@"changeKey%@",CKey]];
}




-(UIColor*)  GetUIColor
{
    CGFloat R  = (CGFloat) 0/255.0;
    CGFloat G = (CGFloat) 146/255.0;
    CGFloat B = (CGFloat) 234/255.0;
    CGFloat alpha = (CGFloat) 1.0;
    
    UIColor *myColorRGB = [ UIColor colorWithRed: R
                                           green: G
                                            blue: B
                                           alpha: alpha
                           ];
    return myColorRGB;
}


@end
