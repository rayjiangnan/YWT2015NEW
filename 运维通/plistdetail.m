//
//  plistdetail.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "plistdetail.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "userapplylist.h"
#import "finishion.h"
#import "pinjia.h"
#import "UIViewController+Extension.h"

@interface plistdetail ()
{
    int num;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@property (weak, nonatomic) IBOutlet UILabel *dh;

@property (weak, nonatomic) IBOutlet UILabel *bt;

@property (weak, nonatomic) IBOutlet UILabel *lx;

@property (weak, nonatomic) IBOutlet UILabel *gzrw;

@property (weak, nonatomic) IBOutlet UILabel *yf;

@property (weak, nonatomic) IBOutlet UILabel *sj;

@property (weak, nonatomic) IBOutlet UILabel *lxr;

@property (weak, nonatomic) IBOutlet UILabel *ywdz;

@property (weak, nonatomic) IBOutlet UILabel *gzsc;

@property (weak, nonatomic) IBOutlet UILabel *nlyq;

@property (weak, nonatomic) IBOutlet UILabel *bz;
@property (nonatomic,strong)NSString *idtt;

@property (weak, nonatomic) IBOutlet UILabel *sq;

@property (weak, nonatomic) IBOutlet UILabel *xqrs;

@property (weak, nonatomic) IBOutlet UIButton *postbtn;

@end

@implementation plistdetail
@synthesize strTtile;

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    int status=[self ChangeStatus:@"Order"];
    if (status==3) {
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
    NSLog(@"plistdetail:%@",urlStr);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
 
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject      );
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict2=responseObject;
        NSDictionary *dict=dict2[@"ResultObject"];
        
        self.xqrs.text=[NSString stringWithFormat:@"%@",dict[@"PersonNum"]];
        NSString *sta=[NSString stringWithFormat:@"%@",dict[@"Status"]];
        NSLog(@"%@----",sta);
        if ([sta isEqualToString:@"0"]) {
            self.postbtn.hidden=NO;
            num=1;
        }else if([sta isEqualToString:@"30"]&[[NSString stringWithFormat:@"%@",dict[@"FlowRight"]] isEqualToString:@"1"]){
            [self.postbtn setTitle:@"完成运维" forState:UIControlStateNormal];
        self.postbtn.hidden=NO;
            num=2;
        }else if([sta isEqualToString:@"90"]&[[NSString stringWithFormat:@"%@",dict[@"FlowRight"]] isEqualToString:@"1"]){
            [self.postbtn setTitle:@"评价运维" forState:UIControlStateNormal];
            self.postbtn.hidden=NO;
            num=3;
        }else{
         self.postbtn.hidden=YES;
        }
        if (![sta isEqualToString:@"0"]) {
            [self ChangeRecord:strTtile key:@"Order"];
        }
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
        //        [self idt:dict[@"Order_ID"]];
        self.yf.text=[NSString stringWithFormat:@"%@",dict[@"Freight"]];
        self.lxr.text=[NSString stringWithFormat:@"%@  %@",dict[@"ContactMan"],dict[@"ContactMobile"]];
        self.ywdz.text=dict[@"Task_Address"];
        self.bt.text=dict[@"OrderTitle"];
        NSString *st=dict[@"OrderType_Name"];
        self.sq.text=[NSString stringWithFormat:@"%@人申请",dict[@"ApplyUserNumber"]];
        self.lx.text=st;
        self.nlyq.text=dict[@"AbilityRequest"];
        self.gzrw.text=dict[@"OrderTask"];
        self.gzsc.text=[NSString stringWithFormat:@"%@",dict[@"TaskTimeLen"]];
        self.bz.text=dict[@"Remark"];
        
        
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
    if ([vc isKindOfClass:[userapplylist class]]) {
        userapplylist *detai=vc;
        [detai setValue:_idtt forKey:@"strTtile"];
        
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
        
    }
}


- (IBAction)postapply:(id)sender {
    if (num==1) {
       [self performSegueWithIdentifier:@"sq" sender:nil];
    }else if(num==2){
    
      [self performSegueWithIdentifier:@"wc" sender:nil];
    }else if(num==3){
        
        [self performSegueWithIdentifier:@"pj" sender:nil];
    }
   
}


@end
