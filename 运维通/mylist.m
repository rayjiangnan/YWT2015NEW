//
//  mylist.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "mylist.h"
#import "MBProgressHUD+MJ.h"
#import "mycell.h"
#import "applyorder.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

@interface mylist ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
   int pagnum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;

@end

@implementation mylist

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *usertype = [userDefaultes stringForKey:@"usertype"];
    if ([usertype isEqualToString:@"40"]) {
        self.tabBarController.tabBar.hidden=YES;
    }else{
        
        self.tabBarController.tabBar.hidden=NO;
    }
    pagnum=0;
    int chageStatus=[self ChangePageInit:@"Order"];
    if (chageStatus==4) {
        [self network2];
        [self.tableview reloadData];
    }
    else if (chageStatus==2) {
        
    }
    else if (chageStatus==3) {
        //[self ChangeLoad];
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self repeatnetwork];
    self.tableview.rowHeight=155;
    
    [self network2];
    [self.tableview reloadData];
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
    static NSString *ID = @"mycell";
    mycell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"mycell" owner:nil options:nil] lastObject];
    }
    cell.dh.text=[NSString stringWithFormat:@"%@",dict2[@"OrderNo"]];
    cell.zt.text=[NSString stringWithFormat:@"%@",dict2[@"Status_Name"]];
    cell.bt.text=[NSString stringWithFormat:@"%@",dict2[@"OrderTitle"]];
    cell.dz.text=[NSString stringWithFormat:@"%@",dict2[@"Task_Address"]];
    
    cell.dz.lineBreakMode = UILineBreakModeWordWrap;
    cell.dz.numberOfLines = 0;
    
    
    cell.sq.text=[NSString stringWithFormat:@"%@人申请",dict2[@"ApplyNum"]];
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
    
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSString *dt3=dict2[@"CreateDateTime"];;
//    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
//    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
//    // NSLog(@"%@",dt3);
//    NSString * timeStampString3 =dt3;
//    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
//    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
//    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
//    [objDateformat3 setDateFormat:@"MM-dd"];
    cell.sj.text=[self DateFormartMD:dict2[@"CreateDateTime"]];//[objDateformat3 stringFromDate: date3];
    

    
//    NSString *img2=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
//    
//    NSURL *imgurl=[NSURL URLWithString:img2];
//    cell.img.image= [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
    NSString *img2=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"SuppImg"]];
    NSURL *imgurl=[NSURL URLWithString:img2];
    [cell.img setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img2]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
    
     [self performSegueWithIdentifier:@"xiangxi" sender:nil];
}

-(void)network2{
    int indes=0;
 
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getlistforall&q0=%d",urlt,indes];
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }else{
            NSMutableArray *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
            if (dictarr !=nil && dictarr.count < 10) {
                self.tableview.footer = nil;
            }
            else if(dictarr.count >=10 && self.tableview.footer == nil)
            {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            [self netwok:dictarr];
            [self.tableview reloadData];
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络异常！"];
            return ;
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
}

-(void )repeatnetwork{
    
    
    self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
}

-(void)loadMoreData
{
    
    pagnum=pagnum+1;
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getlistforall&q0=%d",urlt,pagnum];

    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }else{
            NSMutableArray *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
            if (dictarr !=nil && dictarr.count < 10) {
                self.tableview.footer = nil;
            }
            else if(dictarr.count >=10 && self.tableview.footer == nil)
            {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            [_tgs addObjectsFromArray:dictarr];
            [self.tableview reloadData];
        }
        [self.tableview.footer endRefreshing];
        self.tableview.footer.autoChangeAlpha=YES;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[applyorder class]]) {
        applyorder *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"Order_ID"];
        [detai setValue:orderq forKey:@"strTtile"];
        
    }
   
}



@end
