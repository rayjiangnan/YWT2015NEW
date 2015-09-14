//
//  applyperson.m
//  运维通
//
//  Created by 南江 on 15/9/14.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "applyperson.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"


@interface applyperson ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *ordernum;
@property (weak, nonatomic) IBOutlet UIImageView *x1;
@property (weak, nonatomic) IBOutlet UIImageView *x2;
@property (weak, nonatomic) IBOutlet UIImageView *x3;
@property (weak, nonatomic) IBOutlet UIImageView *x4;
@property (weak, nonatomic) IBOutlet UIImageView *x5;

@property (weak, nonatomic) IBOutlet UIImageView *f1;
@property (weak, nonatomic) IBOutlet UIImageView *f2;
@property (weak, nonatomic) IBOutlet UIImageView *f3;
@property (weak, nonatomic) IBOutlet UIImageView *f4;
@property (weak, nonatomic) IBOutlet UIImageView *f5;

@property (weak, nonatomic) IBOutlet UILabel *xl;
@property (weak, nonatomic) IBOutlet UILabel *byxy;

@property (weak, nonatomic) IBOutlet UILabel *bysj;

@property (weak, nonatomic) IBOutlet UILabel *zymc;

@property (weak, nonatomic) IBOutlet UITextView *zyms;

@property (weak, nonatomic) IBOutlet UITextView *zc;


@end

@implementation applyperson
@synthesize strTtile;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self netword];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)netword
{
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=userorderdetail&q0=%@",urlt,strTtile];
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict2=responseObject;
        if (![dict2[@"ResultObject"] isEqual:[NSNull null]]) {
            NSDictionary *dict=dict2[@"ResultObject"];
            if (![dict[@"RealName"] isEqual:[NSNull null]]) {
                self.name.text=dict[@"RealName"];
            }
            self.ordernum.text=[NSString stringWithFormat:@"%@",dict[@"OrderFinishNum"]];
            self.xl.text=[NSString stringWithFormat:@"%@",dict[@"HighestEducation"]];
            self.byxy.text=[NSString stringWithFormat:@"%@",dict[@"Finish_School"]];
            
            if (![dict[@"GraduationData"] isEqual:[NSNull null]]) {
                
                NSString *dt1=dict[@"GraduationData"];
                dt1=[dt1 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
                dt1=[dt1 stringByReplacingOccurrencesOfString:@")/" withString:@""];
                //NSLog(@"%@",dt1);
                NSString * timeStampString =dt1;
                NSTimeInterval _interval=[timeStampString doubleValue] / 1000;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
                [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
                
                // NSLog(@"%@",dt1);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                
                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
                [formatter setTimeZone:timeZone];
                
                NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
                
                NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
                //时间转时间戳的方法:
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
                //  NSLog(@"timeSp:%@",timeSp); //时间戳的值
                //时间戳转时间的方法
                double d = [dt1 doubleValue];
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:d];
                //  NSLog(@"%f  = %@",d,confromTimesp);
                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                // NSLog(@"confromTimespStr =  %@",confromTimespStr);
                self.bysj.text=confromTimespStr;

            }
            self.zc.text=[NSString stringWithFormat:@"%@",dict[@"Specialty"]];
            self.zyms.text=[NSString stringWithFormat:@"%@",dict[@"SkillDescription"]];
            self.zymc.text=[NSString stringWithFormat:@"%@",dict[@"SpecialtyName"]];
            
            NSString *xin=[NSString stringWithFormat:@"%@",dict[@"Stars"]];
            if ([xin isEqualToString:@"5"]) {
                
            }
            if ([xin isEqualToString:@"4"]) {
                self.x5.image=[UIImage imageNamed:@"hxx"];
            }
            if ([xin isEqualToString:@"3"]) {
                
                self.x4.image=[UIImage imageNamed:@"hxx"];
                self.x5.image=[UIImage imageNamed:@"hxx"];
            }
            if ([xin isEqualToString:@"2"]) {
                
                self.x3.image=[UIImage imageNamed:@"hxx"];
                self.x4.image=[UIImage imageNamed:@"hxx"];
                self.x5.image=[UIImage imageNamed:@"hxx"];
            }
            if ([xin isEqualToString:@"1"]) {
                
                self.x2.image=[UIImage imageNamed:@"hxx"];
                self.x3.image=[UIImage imageNamed:@"hxx"];
                self.x4.image=[UIImage imageNamed:@"hxx"];
                self.x5.image=[UIImage imageNamed:@"hxx"];
            }
            if ([xin isEqualToString:@"0"]) {
                self.x1.image=[UIImage imageNamed:@"hxx"];
                self.x2.image=[UIImage imageNamed:@"hxx"];
                self.x3.image=[UIImage imageNamed:@"hxx"];
                self.x4.image=[UIImage imageNamed:@"hxx"];
                self.x5.image=[UIImage imageNamed:@"hxx"];
            }
            
            
            NSString *fen=[NSString stringWithFormat:@"%@",dict[@"ScoreAvg"]];
            if ([xin isEqualToString:@"0"]) {
                self.f1.image=[UIImage imageNamed:@"hxx"];
                self.f2.image=[UIImage imageNamed:@"hxx"];
                self.f3.image=[UIImage imageNamed:@"hxx"];
                self.f4.image=[UIImage imageNamed:@"hxx"];
                self.f5.image=[UIImage imageNamed:@"hxx"];
            }else if([fen isEqualToString:@"1"]) {
                self.f2.image=[UIImage imageNamed:@"hxx"];
                self.f3.image=[UIImage imageNamed:@"hxx"];
                self.f4.image=[UIImage imageNamed:@"hxx"];
                self.f5.image=[UIImage imageNamed:@"hxx"];
            }else if([fen isEqualToString:@"2"]) {
                
                self.f3.image=[UIImage imageNamed:@"hxx"];
                self.f4.image=[UIImage imageNamed:@"hxx"];
                self.f5.image=[UIImage imageNamed:@"hxx"];
            }else if([fen isEqualToString:@"3"]) {
                
                self.f4.image=[UIImage imageNamed:@"hxx"];
                self.f5.image=[UIImage imageNamed:@"hxx"];
            }else if([fen isEqualToString:@"4"]) {
                
                self.f5.image=[UIImage imageNamed:@"hxx"];
                
            }else if([fen isEqualToString:@"5"]) {
                
            }

            
            NSLog(@"加载数据完成。%@",dict);
 
        }
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];

}



@end
