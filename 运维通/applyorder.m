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
#import "UIImageView+WebCache.h"

@interface applyorder ()
{
    NSString *strTel;
}
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

@property (weak, nonatomic) IBOutlet UITextView *bz;
@property (nonatomic,strong)NSString *idtt;

@property (weak, nonatomic) IBOutlet UIImageView *imgComapny;

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

@property (weak, nonatomic) IBOutlet UIImageView *imgIsHaveApplay;
@property (weak, nonatomic) IBOutlet UILabel *lblIsHaveApplay;


@property (weak, nonatomic) IBOutlet UIButton *postbtn;

- (IBAction)btnTelCompanyClick:(id)sender;


@end

@implementation applyorder
@synthesize strTtile;

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    
    [self.view setNeedsDisplay];
    int status=[self ChangeStatus:@"Order"];
    if (status==3) {
         self.postbtn.hidden=YES;
        [self requestaaa];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollview.contentSize=CGSizeMake(320, 800);
    
    //self.postbtn.hidden=YES;
    [self requestaaa];
}


-(void)requestaaa
{
    NSString *Create_User = [self GetUserID];
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getitem&q0=%@&q1=%@",urlt,mystring2,Create_User];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    NSLog(@"applyorder:%@",urlStr);
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }

        
        NSDictionary *dict=json[@"ResultObject"];
        self.dh.text=dict[@"OrderNo"];

        self.sj.text=[self DateFormartYMD:dict[@"CreateDateTime"]];//[objDateformat3 stringFromDate: date3];
        [self idt:dict[@"Order_ID"]];
        self.fdr.text=dict[@"Company"];
        self.wcds.text=[NSString stringWithFormat:@"%@",dict[@"OrderFinishNum"]];
        //        [self idt:dict[@"Order_ID"]];
        self.yf.text=[NSString stringWithFormat:@"%@",dict[@"Freight"]];
        self.lxr.text=[NSString stringWithFormat:@"%@  %@",dict[@"ContactMan"],dict[@"ContactMobile"]];
        strTel=dict[@"ContactMobile"];
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
            self.imgIsHaveApplay.hidden=NO;
            self.lblIsHaveApplay.hidden=NO;
        }
        
        NSString *img2=[NSString stringWithFormat:@"%@%@",urlt,dict[@"SuppImg"]];
        NSURL *imgurl=[NSURL URLWithString:img2];
        [self.imgComapny setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img2]];
        
        
        UIImage *img=  [UIImage imageNamed:@"hxx"];
        int Stars=[dict[@"Stars"] intValue];
        if (Stars==0) {
            
            self.x5.image=img;
            self.x4.image=img;
            self.x3.image=img;
            self.x2.image=img;
            self.x1.image=img;
        }
        else
        {
            if (Stars<=4)
            {
                self.x5.image=img;
            }
            if (Stars<=3)
            {
                self.x4.image=img;
            }
            if (Stars<=2)
            {
                self.x3.image=img;
            }
            if (Stars==1)
            {
                self.x2.image=img;
            }
        }
        
        
        int fen=[dict[@"ScoreAvg"] intValue];
        if (fen==0) {
            self.f5.image=img;
            self.f4.image=img;
            self.f3.image=img;
            self.f2.image=img;
            self.f1.image=img;
        }
        else
        {
            if (fen<=4){
                self.f5.image=img;
            }
            if (fen<=3){
                self.f4.image=img;
            }
            if (fen<=2){
                self.f3.image=img;
            }
            if (fen==1){
                self.f2.image=img;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return;
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

- (IBAction)btnTelCompanyClick:(id)sender {
    [self tel:strTel];
}
@end
