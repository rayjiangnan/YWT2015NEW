//
//  OnlineApprovalCompanyList.m
//  YWTIOS
//
//  Created by ritacc on 15/8/15.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "OnlineApprovalCompanyList.h"
#import "OnlineApprovalCompanyCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "ApplyApproval.h"
#import "OnlineApprovalView.h"

@interface OnlineApprovalCompanyList ()<UITableViewDataSource,UITableViewDelegate>
{
    int num;
    int pg;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@end

@implementation OnlineApprovalCompanyList


-(void)viewDidAppear:(BOOL)animated{
      [self indexchang:0];
      [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    num=0;
    [self repeatnetwork];
  
    self.tableview.rowHeight=120;
    NSLog(@"加载数据。。。。");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"ApprovalCompanyCell";
    OnlineApprovalCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"OnlineApprovalCompanyCell" owner:nil options:nil] lastObject];
    }
    //NSLog(@"%@",dict2[@"Prodeuct_Model"]);
    cell.lblApplyNo.text=[NSString stringWithFormat:@"编号：%@",dict2[@"ApplyNo"]];
    cell.lblTime.text= [self DateFormartMDHM:dict2[@"ApplyDate"]];
    cell.lblType.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyType"]];
    cell.lblContent.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyContent"]];
    cell.lblContent.lineBreakMode = UILineBreakModeWordWrap;
    cell.lblContent.numberOfLines = 0;
    
    cell.lblStatusName.text= [NSString stringWithFormat:@"%@",dict2[@"ApprovalStatusName"]];
    cell.lblUser.text=[NSString stringWithFormat:@"%@",dict2[@"RealName"]];
    if ([[NSString stringWithFormat:@"%@",dict2[@"UserImg"]] isEqualToString:@"/Images/defaultPhoto.png"]==NO) {
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        UIImage *imgUserimg=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [cell.UserImg setImage:imgUserimg];
    }

    return cell;
}


- (IBAction)indexchang:(UISegmentedControl *)sender {
    
    
    NSInteger colum=sender.selectedSegmentIndex;
   pg=colum-1;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
  NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    
    //分状态展示 0 未审核 1 已审核 -1 全部
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OnlineApproval.ashx?action=getcompanylist&q0=%@&q1=0&q2=%d",urlt,Create_User,pg];
    NSLog(@"%@",urlStr2);
    
        self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict2=responseObject;
          NSMutableArray *dictarr=[[dict2 objectForKey:@"ResultObject"] mutableCopy];
        NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
        num=[dict3[@"OnlineApproval_ID"] intValue];
        [self netwok:dictarr];
        [self.tableview reloadData];
        NSLog(@"加载数据完成。");
       [self.tableview.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
            
        }];
    self.tableview.header.autoChangeAlpha = YES;
    [self.tableview.header beginRefreshing];
    
    
    
    
}




-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}

/***数据跳转****/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSIndexPath *path=[self.tableview indexPathForSelectedRow];
    NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
    NSString *strStatus=  [NSString stringWithFormat:@"%@",rowdata[@"ApprovalStatus"]];
    
    if ([strStatus isEqualToString:@"0"]==NO){
        [self performSegueWithIdentifier:@"viewitem" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"approvalItem" sender:nil];
    }
}


-(NSMutableArray *)repeatnetwork{
    
    
    self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    return _tgs;
    
    
}


-(void)loadMoreData
{
    
    num=num+1;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    //分状态展示 0 未审核 1 已审核 -1 全部
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OnlineApproval.ashx?action=getcompanylist&q0=%@&q1=0&q2=%d",urlt,myString,pg];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        NSArray *dictarr=[dict objectForKey:@"ResultObject"];
        if(![dictarr isEqual:[NSNull null]])
        {
            if (dictarr.count>0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                num=[dict3[@"OnlineApproval_ID"] intValue];
                           [_tgs addObjectsFromArray:dictarr];
                           [self.tableview reloadData];
                           
                           }
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
    if ([vc isKindOfClass:[ApplyApproval class]]) {
        ApplyApproval *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"OnlineApproval_ID"]];
        [detai setValue:orderq forKey:@"strTtile"];
    }
    if ([vc isKindOfClass:[OnlineApprovalView class]]) {
        OnlineApprovalView *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"OnlineApproval_ID"]];
        [detai setValue:orderq forKey:@"strTtile"];
    }
}



@end