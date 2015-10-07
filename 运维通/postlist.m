//
//  postlist.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "postlist.h"
#import "postcell.h"
#import "MBProgressHUD+MJ.h"
#import "plistdetail.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"

@interface postlist ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    int num;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;


@end

@implementation postlist

-(void)viewDidAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden=YES;
    int chageStatus=[self ChangePageInit:@"Order"];
    if (chageStatus==4 || chageStatus==3) {
        num=0;
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
    self.tabBarController.tabBar.hidden=YES;
    
    num=0;

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
    static NSString *ID = @"post";
    postcell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"postcell" owner:nil options:nil] lastObject];
    }
    cell.dh.text=[NSString stringWithFormat:@"%@",dict2[@"OrderNo"]];
    cell.zt.text=[NSString stringWithFormat:@"%@",dict2[@"Status_Name"]];
    cell.bt.text=[NSString stringWithFormat:@"%@",dict2[@"OrderTitle"]];
    cell.fy.text=[NSString stringWithFormat:@"%@",dict2[@"Freight"]];
    cell.rs.text=[NSString stringWithFormat:@"%@",dict2[@"PersonNum"]];
    cell.dz.text=[NSString stringWithFormat:@"%@",dict2[@"Task_Address"]];
    cell.sq.text=[NSString stringWithFormat:@"%@人申请",dict2[@"ApplyNum"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    cell.sj.text=[self DateFormartMD:dict2[@"CreateDateTime"]];//[objDateformat3 stringFromDate: date3];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
   
 [self performSegueWithIdentifier:@"xiangxi" sender:nil];
    
    
}

-(void)network2{
    int indes=0;
    NSString *myString =[self GetUserID];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getlistforsupplier&q0=%d&q1=%@",urlt,indes,myString];
    
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
            if (dictarr !=nil && dictarr.count >= 10) {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            else
            {
                self.tableview.footer = nil;
            }
            [self netwok:dictarr];
            [self.tableview reloadData];
        }
        [self.tableview.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];

}


-(void)loadMoreData
{
    num=num+1;
    NSString *myString =[self GetUserID];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getlistforsupplier&q0=%d&q1=%@",urlt,num,myString];
    NSLog(@"%@",urlStr2);
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
            if (dictarr !=nil && dictarr.count >= 10) {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            else
            {
                self.tableview.footer = nil;
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
    if ([vc isKindOfClass:[plistdetail class]]) {
        plistdetail *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"Order_ID"];
        [detai setValue:orderq forKey:@"strTtile"];
        
    }
    
}

@end
