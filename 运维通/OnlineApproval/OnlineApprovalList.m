//
//  OnlineApprovalList.m
//  YWTIOS
//
//  Created by ritacc on 15/8/14.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "OnlineApprovalList.h"
#import "OnlineApprovalUserCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "OnlineApprovalAdd.h"
#import "OnlineApprovalView.h"



@interface OnlineApprovalList ()<UITableViewDataSource,UITableViewDelegate>{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@end

@implementation OnlineApprovalList


-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    int chageStatus=[self ChangePageInit:@"OnlineApproval"];
    if (chageStatus==1 || chageStatus==4) {
        [self network2];
        [self.tableview reloadData];
    }
    else if (chageStatus==2) {
        
    }
    else if (chageStatus==3) {
        [self ChangeLoad];
    }
    self.tableview.rowHeight=120;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self repeatnetwork];
    
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
    static NSString *ID = @"CellTableViewCell";
    OnlineApprovalUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"OnlineApprovalUserCell" owner:nil options:nil] lastObject];
    }
    //NSLog(@"%@",dict2[@"Prodeuct_Model"]);    
    cell.lblApplyNo.text=[NSString stringWithFormat:@"编号：%@",dict2[@"ApplyNo"]];
    cell.lblTime.text= [self DateFormartMDHM:dict2[@"ApplyDate"]];
    cell.lblType.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyType"]];
    cell.lblContent.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyContent"]];
    
     cell.lblContent.numberOfLines = 0;
    cell.lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.lblStatusName.text= [NSString stringWithFormat:@"%@",dict2[@"ApprovalStatusName"]];
    
    return cell;
}

-(void)network2{
     num=0;
//self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OnlineApproval.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,num];
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
            if (dictarr.count < 10) {
                self.tableview.footer = nil;
            }
            else if(dictarr.count >= 10 && self.tableview.footer == nil)
            {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            [self netwok:dictarr];
           
            [self.tableview reloadData];
            NSLog(@"加载数据完成。");
        }
//        [self.tableview.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
//}];
//    [self.tableview.header beginRefreshing];
    
}


-(NSMutableArray *)repeatnetwork{
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    return _tgs;
}
-(void) ChangeLoad
{
    NSString *strid=[self ChangeGetChageID:@"OnlineApproval"];
    int _pagenum=  [self ChangeNnm:_tgs  ItemIDKey:@"CustomerID"  ID:strid];
    if (_pagenum >=0) {
        [self  loadMoreData: _pagenum IsChangeAdd:FALSE];
    }
}

-(void)loadMoreData
{
    num=num+1;
    [self loadMoreData : num IsChangeAdd:true];
}

-(void)loadMoreData :(int) ChageNum IsChangeAdd:(BOOL) _IsChange
{
//    int index=num;
//    num=index+1;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OnlineApproval.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,ChageNum];
    //NSLog(@"%@",urlStr2);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict2=responseObject;
         NSMutableArray *dictarr=[[dict2 objectForKey:@"ResultObject"]mutableCopy];
         NSLog(@"-----%@",dictarr);
        if(![dictarr isEqual:[NSNull null]])
        {
            if (dictarr.count < 10) {
                self.tableview.footer = nil;
            }
            else if(dictarr.count >= 10 && self.tableview.footer == nil)
            {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            if (dictarr.count>0) {
                if (_IsChange) {
                    [_tgs addObjectsFromArray:dictarr];
                }
                else
                {
                    NSString *strid=[self ChangeGetChageID:@"OnlineApproval"];
                    if (![self ChangeData:_tgs NewLoadRecords:dictarr ItemIDKey:@"OnlineApproval_ID"  ID:strid]) {
                        NSLog(@"加载数据出错。");
                    }
                }
                [self.tableView reloadData];
            }
            [_tgs addObjectsFromArray:dictarr];
            [self.tableView reloadData];
        }
        [self.tableView.footer endRefreshing];
        self.tableView.footer.autoChangeAlpha=YES;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}



-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}

/***数据跳转****/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"view" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[OnlineApprovalView class]]) {
        OnlineApprovalView *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"OnlineApproval_ID"]];
        [detai setValue:orderq forKey:@"strTtile"];
    }
}



@end