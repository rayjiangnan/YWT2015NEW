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
    [self requestaaa];
      [self.view setNeedsDisplay];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollview.contentSize=CGSizeMake(320, 800);
    
    
}


-(void)requestaaa
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getitem&q0=%@&q1=%@",urlt,mystring2,myString];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    NSLog(@"%@",urlStr);
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",  urlStr);
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict2=responseObject;
        NSDictionary *dict=dict2[@"ResultObject"];
        
        self.dh.text=dict[@"OrderNo"];
        NSString *dt3=dict[@"CreateDateTime"];
        dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
        // NSLog(@"%@",dt3);
        NSString * timeStampString3 =dt3;
        NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
        NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
        NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
        [objDateformat3 setDateFormat:@"yyyy-MM-dd"];
        self.sj.text=[objDateformat3 stringFromDate: date3];
        [self idt:dict[@"Order_ID"]];
        self.fdr.text=dict[@"Company"];
        self.wcds.text=[NSString stringWithFormat:@"%@",dict[@"OrderFinishNum"]];
//        [self idt:dict[@"Order_ID"]];
        self.yf.text=[NSString stringWithFormat:@"%@",dict[@"Freight"]];
        self.lxr.text=dict[@"ContactMan"];
        self.dh.text=dict[@"ContactMobile"];
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
        
        
        
        
        
        
        
        NSString *xin=[NSString stringWithFormat:@"%@",dict[@"Stars"]];
        if ([xin isEqualToString:@"0"]) {
            
        }else if([xin isEqualToString:@"1"]) {
            self.x1.hidden=NO;
        }else if([xin isEqualToString:@"2"]) {
            self.x1.hidden=NO;
            self.x2.hidden=NO;
        }else if([xin isEqualToString:@"3"]) {
            self.x1.hidden=NO;
            self.x2.hidden=NO;
            self.x3.hidden=NO;
        }else if([xin isEqualToString:@"4"]) {
            self.x1.hidden=NO;
            self.x2.hidden=NO;
            self.x3.hidden=NO;
            self.x4.hidden=NO;
        }else if([xin isEqualToString:@"5"]) {
            self.x1.hidden=NO;
            self.x2.hidden=NO;
            self.x3.hidden=NO;
            self.x4.hidden=NO;
            self.x5.hidden=NO;
        }
        
        
        NSString *fen=[NSString stringWithFormat:@"%@",dict[@"ScoreAvg"]];
        if ([xin isEqualToString:@"0"]) {
            
        }else if([fen isEqualToString:@"1"]) {
            self.f1.hidden=NO;
        }else if([fen isEqualToString:@"2"]) {
            self.f1.hidden=NO;
            self.f2.hidden=NO;
        }else if([fen isEqualToString:@"3"]) {
            self.f1.hidden=NO;
            self.f2.hidden=NO;
            self.f3.hidden=NO;
        }else if([fen isEqualToString:@"4"]) {
            self.f1.hidden=NO;
            self.f2.hidden=NO;
            self.f3.hidden=NO;
            self.f4.hidden=NO;
        }else if([fen isEqualToString:@"5"]) {
            self.f1.hidden=NO;
            self.f2.hidden=NO;
            self.f3.hidden=NO;
            self.f4.hidden=NO;
            self.f5.hidden=NO;
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
