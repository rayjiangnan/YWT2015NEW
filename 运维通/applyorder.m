//
//  applyorder.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "applyorder.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "postapply.h"
#import "UIViewController+Extension.h"

@interface applyorder ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UILabel *fdr;

@property (weak, nonatomic) IBOutlet UILabel *wcds;

@property (weak, nonatomic) IBOutlet UILabel *dh;

@property (weak, nonatomic) IBOutlet UILabel *bt;

@property (weak, nonatomic) IBOutlet UILabel *lx;

@property (weak, nonatomic) IBOutlet UITextView *gzrw;

@property (weak, nonatomic) IBOutlet UILabel *yf;

@property (weak, nonatomic) IBOutlet UILabel *sj;

@property (weak, nonatomic) IBOutlet UILabel *lxr;

@property (weak, nonatomic) IBOutlet UILabel *ywdz;

@property (weak, nonatomic) IBOutlet UILabel *gzsc;

@property (weak, nonatomic) IBOutlet UILabel *nlyq;

@property (weak, nonatomic) IBOutlet UILabel *bz;
@property (nonatomic,strong)NSString *idtt;

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
@property (weak, nonatomic) IBOutlet UIButton *postbtn;



@end

@implementation applyorder
@synthesize strTtile;

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
     self.postbtn.hidden=YES;
    
    [self requestaaa];
    [self.view setNeedsDisplay];
    
    [self ChangeItemInit:@"Order"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollview.contentSize=CGSizeMake(320, 800);
    
    
}


-(void)requestaaa
{
    NSString *Create_User = [self GetUserID];
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getitem&q0=%@&q1=%@",urlt,mystring2,Create_User];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    NSLog(@"applyorder:%@",urlStr);
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",  urlStr);
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict2=responseObject;
        NSDictionary *dict=dict2[@"ResultObject"];
        
        self.dh.text=dict[@"OrderNo"];
//        NSString *dt3=dict[@"CreateDateTime"];
//        dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
//        dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
//        // NSLog(@"%@",dt3);
//        NSString * timeStampString3 =dt3;
//        NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
//        NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
//        NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
//        [objDateformat3 setDateFormat:@"yyyy-MM-dd"];
        
            self.sj.text=[self DateFormartYMD:dict[@"CreateDateTime"]];//[objDateformat3 stringFromDate: date3];
            [self idt:dict[@"Order_ID"]];
            self.fdr.text=dict[@"Company"];
            self.wcds.text=[NSString stringWithFormat:@"%@",dict[@"OrderFinishNum"]];
            //        [self idt:dict[@"Order_ID"]];
            self.yf.text=[NSString stringWithFormat:@"%@",dict[@"Freight"]];
            self.lxr.text=[NSString stringWithFormat:@"%@  %@",dict[@"ContactMan"],dict[@"ContactMobile"]];
            self.ywdz.text=dict[@"Task_Address"];
            self.bt.text=dict[@"OrderTitle"];
            NSString *st=dict[@"OrderType_Name"];
            self.lx.text=st;
            self.nlyq.text=dict[@"AbilityRequest"];
            self.gzrw.text=dict[@"OrderTask"];
            self.gzsc.text=[NSString stringWithFormat:@"%@",dict[@"TaskTimeLen"]];
            self.bz.text=dict[@"Remark"];



            NSString *apply=[NSString stringWithFormat:@"%@",dict[@"IsHaveApplay"]];
        if (![apply isEqualToString:@"1"]) {
            self.postbtn.hidden=NO;
        }
        else
        {
            self.postbtn.hidden=YES;
        }         
        
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
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
        
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
}

-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[postapply class]]) {
        postapply *detai=vc;
        [detai setValue:_idtt forKey:@"strTtile"];
    }
    
}


- (IBAction)postapply:(id)sender {
  [self performSegueWithIdentifier:@"sq" sender:nil];  
}

@end
