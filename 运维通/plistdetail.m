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
    int OrderStatus;
    NSString * ApplyNum;
    NSString *_ywUserTel;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


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

//@property (weak, nonatomic) IBOutlet UILabel *sq;

@property (weak, nonatomic) IBOutlet UILabel *xqrs;

@property (weak, nonatomic) IBOutlet UIButton *postbtn;
- (IBAction)btnApplyUser:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *btnApplyUserCount;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmUser;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmUserTel;
@property (weak, nonatomic) IBOutlet UIButton *btnApplyUserTel;
- (IBAction)btnApplyUserTelClick:(id)sender;



@end

@implementation plistdetail
@synthesize strTtile;

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    int status=[self ChangeStatus:@"Order"];
    if (status==3) {
        [self requestaaa];
    }
//    NSLog(@"%@",ApplyNum);
//    self.btnApplyUserCount.text=[NSString stringWithFormat:@"%@人申请",ApplyNum];
    [self ChangeItemInit:@"Order"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollview.contentSize=CGSizeMake(320, 700);
    OrderStatus=0;
    ApplyNum=@"0";
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
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }
        else
        {
            NSDictionary *dict=json[@"ResultObject"];
            self.xqrs.text=[NSString stringWithFormat:@"%@",dict[@"PersonNum"]];
            NSString *sta=[NSString stringWithFormat:@"%@",dict[@"Status"]];
            NSString *FlowRight=[NSString stringWithFormat:@"%@",dict[@"FlowRight"]];
            if([FlowRight isEqualToString:@"1"])
            {
                if ([sta isEqualToString:@"0"]) {
                    self.postbtn.hidden=NO;
                    num=1;
                }else if([sta isEqualToString:@"30"]){
                    [self.postbtn setTitle:@"完成运维" forState:UIControlStateNormal];
                    self.postbtn.hidden=NO;
                    num=2;
                }else if([sta isEqualToString:@"90"]){
                    [self.postbtn setTitle:@"评价运维" forState:UIControlStateNormal];
                    self.postbtn.hidden=NO;
                    num=3;
                }
            }
            else
            {
                self.postbtn.hidden=YES;
            }
            
            self.dh.text=dict[@"OrderNo"];
            self.sj.text=[self DateFormartYMD:dict[@"CreateDateTime"]];//[objDateformat3 stringFromDate: date3];
            [self idt:dict[@"Order_ID"]];
            //        [self idt:dict[@"Order_ID"]];
            self.yf.text=[NSString stringWithFormat:@"%@",dict[@"Freight"]];
            self.lxr.text=[NSString stringWithFormat:@"%@  %@",dict[@"ContactMan"],dict[@"ContactMobile"]];
            self.ywdz.text=dict[@"Task_Address"];
            self.bt.text=dict[@"OrderTitle"];
            NSString *st=dict[@"OrderType_Name"];
            ApplyNum=dict[@"ApplyUserNumber"];
            self.btnApplyUserCount.text=[NSString stringWithFormat:@"%@人申请",ApplyNum];
            self.lx.text=st;
            self.nlyq.text=dict[@"AbilityRequest"];
            self.gzrw.text=dict[@"OrderTask"];
            self.gzsc.text=[NSString stringWithFormat:@"%@",dict[@"TaskTimeLen"]];
            self.bz.text=dict[@"Remark"];
            
            OrderStatus=[dict[@"Status"] intValue];
            
            if (![dict[@"OrderUsers"] isEqual:[NSNull null]]) {
                NSArray *dict3=dict[@"OrderUsers"];
                if (dict3.count>0) {
                    NSDictionary *dic=[dict3 objectAtIndex:0];
                    if (![dic[@"RealName"] isEqualToString:@""]) {
                        //NSString *dr=[NSString stringWithFormat:@"%@  %@",dic[@"RealName"],dic[@"Mobile"]];
                        self.lblConfirmUser.text=dic[@"RealName"];
                        self.lblConfirmUserTel.text=dic[@"Mobile"];
                        _ywUserTel=[NSString stringWithFormat:@"%@",dic[@"Mobile"]];
                    }
                }
            }

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
    if ([vc isKindOfClass:[userapplylist class]]) {
        userapplylist *detai=vc;
        [detai setValue:_idtt forKey:@"strTtile"];
        [detai setValue:[NSString stringWithFormat:@"%d",OrderStatus] forKey:@"OrderStatus"];
        
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


- (IBAction)btnApplyUser:(id)sender {
    [self performSegueWithIdentifier:@"sq" sender:nil];
}
- (IBAction)btnApplyUserTelClick:(id)sender {
    //
    [self tel:_ywUserTel];
}
@end
