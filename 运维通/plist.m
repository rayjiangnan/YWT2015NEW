//
//  plist.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "plist.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "beginorder.h"
#import "finishion.h"
#import "pinjia.h"
#import "UIViewController+Extension.h"
#import "UIImageView+WebCache.h"

@interface plist ()
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

@property (weak, nonatomic) IBOutlet UILabel *bz;
@property (nonatomic,strong)NSString *idtt;
@property (weak, nonatomic) IBOutlet UILabel *sta;
@property (nonatomic, strong) NSDictionary *tgs;
@property (weak, nonatomic) IBOutlet UIButton *postbtn;

@property (weak, nonatomic) IBOutlet UIImageView *suppimg;

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
- (IBAction)btnTelClick:(id)sender;

@end

@implementation plist
@synthesize strTtile;

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    
    int status=[self ChangeStatus:@"Order"];
    if (status==3) {
        self.postbtn.hidden=YES;
        [self requestaaa];
    }
    
    [self ChangeItemInit:@"Order"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollview.contentSize=CGSizeMake(320, 800);
    
    [self requestaaa];
}


-(void)requestaaa
{
    NSString *myString =[self GetUserID];
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getitem&q0=%@&q1=%@",urlt,mystring2,myString];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    NSLog(@"plist%@",urlStr);
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",  urlStr);
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict2=responseObject;
        NSDictionary *dict=dict2[@"ResultObject"];
        
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
        self.sta.text=dict[@"Status_Name"];


        NSString *img2=[NSString stringWithFormat:@"%@%@",urlt,dict[@"SuppImg"]];
        NSURL *imgurl=[NSURL URLWithString:img2];
        [self.suppimg setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img2]];
        
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
            if (Stars<=4){
                self.x5.image=img;
            }
            if (Stars<=3){
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

        
        int flowright=[dict[@"FlowRight"] intValue];
        if (flowright==1) {
            self.postbtn.hidden=NO;
            int status=[dict[@"Status"] intValue];
            NSString *nextstatus=[NSString stringWithFormat:@"%@",dict[@"Next_Status_Name"]];
            
            [self.postbtn setTitle:nextstatus forState:UIControlStateNormal];
            
            if (status ==90) {
                [self.postbtn setTitle:@"维运评价" forState:UIControlStateNormal];
            }
            else if (status ==25)
            {
                [self.postbtn setTitle:@"开始运维" forState:UIControlStateNormal];
            }
        }
        else
        {
            self.postbtn.hidden=YES;
        }

        _tgs=dict;
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
    [self requestaaa];
    id vc=segue.destinationViewController;
  
    if ([vc isKindOfClass:[beginorder class]]) {
        beginorder *detai=vc;
        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
        [detai setValue:mystring2 forKey:@"strTtile"];
        
    }
    if ([vc isKindOfClass:[finishion class]]) {
        finishion *detai=vc;
        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
        [detai setValue:mystring2 forKey:@"strTtile"];
        
    }
    if ([vc isKindOfClass:[pinjia class]]) {
        pinjia *detai=vc;
        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
        [detai setValue:mystring2 forKey:@"strTtile"];
        
    }}

- (IBAction)postbtn:(id)sender {
    NSDictionary *dict=_tgs;
    NSString *status=[NSString stringWithFormat:@"%@",dict[@"Status"]];
    
    if ([status isEqualToString:@"21"]) {
        [self performSegueWithIdentifier:@"begin" sender:nil];
    }
    if ([status isEqualToString:@"25"]) {
        [self performSegueWithIdentifier:@"begin" sender:nil];
    }
    if ([status isEqualToString:@"30"]&[[NSString stringWithFormat:@"%@",dict[@"FlowRight"]] isEqualToString:@"1"]) {
        [self performSegueWithIdentifier:@"fi" sender:nil];
    }
    if ([status isEqualToString:@"90"]&[[NSString stringWithFormat:@"%@",dict[@"FlowRight"]] isEqualToString:@"1"]) {
        [self performSegueWithIdentifier:@"pj" sender:nil];
    }
}


- (IBAction)btnTelClick:(id)sender {
    [self tel:strTel];
}
@end
