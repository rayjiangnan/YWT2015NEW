//
//  userapplylist.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "userapplylist.h"
#import "MBProgressHUD+MJ.h"
#import "userCell.h"
#import "applyperson.h"

@interface userapplylist ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (nonatomic,assign)int *idtt3;
@end

@implementation userapplylist
@synthesize strTtile;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestaaa];
    [self.tableview reloadData];
    self.tableview.rowHeight=255;
    
    [self ChangeItemInit:@"Order"];
}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    
    _tgs=array;
    return _tgs;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"post";
    userCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"userCell" owner:nil options:nil] lastObject];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    NSString *dt3=dict2[@"Apply_Date"];
//    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
//    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
//    // NSLog(@"%@",dt3);
//    NSString * timeStampString3 =dt3;
//    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
//    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
//    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
//    [objDateformat3 setDateFormat:@"yyyy-MM-dd"];
    cell.time.text=[self DateFormartYMD:dict2[@"Apply_Date"]];//[objDateformat3 stringFromDate: date3];
    
    NSString *lr=[NSString stringWithFormat:@"%@  %@",dict2[@"ContactMan"],dict2[@"ContactMobile"]];
    cell.lxr.text=lr;
    NSString *xin=[NSString stringWithFormat:@"%@",dict2[@"Stars"]];
    if ([xin isEqualToString:@"5"]) {
        
    }
    if ([xin isEqualToString:@"4"]) {
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([xin isEqualToString:@"3"]) {
        
        cell.x4.image=[UIImage imageNamed:@"hxx"];
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([xin isEqualToString:@"2"]) {
        
        cell.x3.image=[UIImage imageNamed:@"hxx"];
        cell.x4.image=[UIImage imageNamed:@"hxx"];
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([xin isEqualToString:@"1"]) {
        
        cell.x2.image=[UIImage imageNamed:@"hxx"];
        cell.x3.image=[UIImage imageNamed:@"hxx"];
        cell.x4.image=[UIImage imageNamed:@"hxx"];
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([xin isEqualToString:@"0"]) {
        cell.x1.image=[UIImage imageNamed:@"hxx"];
        cell.x2.image=[UIImage imageNamed:@"hxx"];
        cell.x3.image=[UIImage imageNamed:@"hxx"];
        cell.x4.image=[UIImage imageNamed:@"hxx"];
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    
    NSString *fen=[NSString stringWithFormat:@"%@",dict2[@"ScoreAvg"]];
    if ([fen isEqualToString:@"5"]) {
        
    }
    if ([fen isEqualToString:@"4"]) {
        cell.f5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([fen isEqualToString:@"3"]) {
        
        cell.f4.image=[UIImage imageNamed:@"hxx"];
        cell.f5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([fen isEqualToString:@"2"]) {
        
        cell.f3.image=[UIImage imageNamed:@"hxx"];
        cell.f4.image=[UIImage imageNamed:@"hxx"];
        cell.f5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([fen isEqualToString:@"1"]) {
        
        cell.f2.image=[UIImage imageNamed:@"hxx"];
        cell.f3.image=[UIImage imageNamed:@"hxx"];
        cell.f4.image=[UIImage imageNamed:@"hxx"];
        cell.f5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([fen isEqualToString:@"0"]) {
        cell.f1.image=[UIImage imageNamed:@"hxx"];
        cell.f2.image=[UIImage imageNamed:@"hxx"];
        cell.f3.image=[UIImage imageNamed:@"hxx"];
        cell.f4.image=[UIImage imageNamed:@"hxx"];
        cell.f5.image=[UIImage imageNamed:@"hxx"];
    }
    cell.wcds.text=[NSString stringWithFormat:@"%@",dict2[@"OrderFinishNum"]];
    cell.text.text=dict2[@"Apply_Content"];
    [cell.btn addTarget:self action:@selector(genz2:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn.tag =indexPath.row;
    [cell.contentView addSubview:cell.btn];
    
    return cell;
}
-(void)genz2:(UIButton *)sender{
    [self idt3:sender.tag];
    NSDictionary *rowdata=[self.tgs objectAtIndex:_idtt3];
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    NSString *orderq=rowdata[@"Platform_Apply_ID"];
    NSString *urlStr =[NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx",urlt] ;
    
    NSString *myString =[self GetUserID];
    
    NSString *str = [NSString stringWithFormat:@"action=comfirmapplyuser&q0=%@&q1=%@&q2=%@",mystring2,orderq,myString];
    NSLog(@"%@?%@",urlStr,str);
    AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:str];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        if ([json[@"ReturnMsg"] isEqualToString:@"Success"]) {
            // 延迟2秒执行：
            double delayInSeconds =0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [MBProgressHUD showSuccess:@"提交成功！"];
            [[self navigationController] popViewControllerAnimated:YES];
            });

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
    
    
    
}
-(int *)idt3:(int *)id1{
    _idtt3=id1;
    return _idtt3;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
  [self performSegueWithIdentifier:@"person" sender:nil];
}



-(void)requestaaa
{
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    int indes=-1;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getlistapplyusers&q0=%@&q1=%d",urlt,mystring2,indes];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }else{
            NSMutableArray *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
//            if (dictarr !=nil && dictarr.count < 10) {
//                self.tableview.footer = nil;
//            }
//            else if(dictarr.count >=10 && self.tableview.footer == nil)
//            {
//                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//            }
            [self netwok:dictarr];
            [self.tableview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[applyperson class]]) {
        applyperson *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"Apply_UserID"];
        [detai setValue:orderq forKey:@"strTtile"];}
}

@end
