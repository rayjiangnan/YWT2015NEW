//
//  CustomerList.m
//  YWTIOS
//
//  Created by ritacc on 15/8/16.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "CustomerList2.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "CustomerEidt.h"
#import "CustomerCell.h"

@interface CustomerList2 ()<UITableViewDataSource,UITableViewDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@end


@implementation CustomerList2

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    [self network2];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;
    [self repeatnetwork];
    self.tableview.rowHeight=60;
    NSLog(@"加载数据。。。。");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"CustomerCell";
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"CustomerCell" owner:nil options:nil] lastObject];
    }
    
    //"CusShort":"简称","CusFullName":"名称","ContactMan","联系人","ContactMobile","联系电话","ContactAddress","地址","Create_User":""
    cell.CusShort.text= [NSString stringWithFormat:@"%@",dict2[@"CusShort"]];;
    
    cell.ContactMan.text= [NSString stringWithFormat:@"%@",dict2[@"ContactMan"]];
    return cell;
}

-(void)network2{
    
    int indes=0;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Customer.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,indes];
 
    
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
            else if(dictarr.count >= 10 && self.tableView.footer == nil)
            {
                self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            [self netwok:dictarr];
            [self.tableView reloadData];
        }
        
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
 
}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}



-(NSMutableArray *)repeatnetwork{
    
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    return _tgs;
    
    
}


-(void)loadMoreData
{
   num=num+1;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Customer.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,num];

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
            else if(dictarr.count >= 10 && self.tableView.footer == nil)
            {
                self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",dict2[@"CusShort"]] forKey:@"CusShort"];
     [userDefaults setObject:[NSString stringWithFormat:@"%@",dict2[@"ContactMan"]] forKey:@"ContactMan"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",dict2[@"ContactMobile"]] forKey:@"ContactMobile"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",dict2[@"ContactAddress"]] forKey:@"ContactAddress"];

    [userDefaults synchronize];
    
  [[self navigationController] popViewControllerAnimated:YES];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[CustomerEidt class]]) {
        CustomerEidt *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        if (path == Nil) {
            return;
        }
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"CustomerID"]];
        [detai setValue:orderq forKey:@"strTtile"];
    }
}
 

@end
