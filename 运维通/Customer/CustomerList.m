//
//  CustomerList.m
//  YWTIOS
//
//  Created by ritacc on 15/8/16.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "CustomerList.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "CustomerEidt.h"
#import "CustomerCell.h"


@interface CustomerList ()<UITableViewDataSource,UITableViewDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@end


@implementation CustomerList

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;

    
    int chageStatus=[self ChangePageInit:@"Customer"];
    if (chageStatus==4) {
        num=0;
        [self network2];

    }
    else if (chageStatus==2) {
        
    }
    else if (chageStatus==3) {
        [self ChangeLoad];
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *addr=@"";
    [userDefaults setObject:addr forKey:@"detaaddr"];
    [userDefaults setObject:addr forKey:@"detaaddr1"];
    [userDefaults setObject:addr forKey:@"detaaddr2"];
    [userDefaults synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;

    
    self.tableview.rowHeight=60;
    NSLog(@"加载数据。。。。");
    
    [self network2];
    [self.tableview reloadData];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)network2{
    
    int indes=0;
    
    NSString *Create_User = [self GetUserID];
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
            if (dictarr !=nil && dictarr.count >= 10) {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            else
            {
                self.tableview.footer = nil;
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




-(void) ChangeLoad
{
    NSString *strid=[self ChangeGetChageID:@"Customer"];
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
    
    NSString *Create_User  =[self GetUserID];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Customer.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,ChageNum];

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
            
            if (_IsChange) {
                [_tgs addObjectsFromArray:dictarr];
            }
            else
            {
                NSString *strid=[self ChangeGetChageID:@"Customer"];
                if (![self ChangeData:_tgs NewLoadRecords:dictarr ItemIDKey:@"CustomerID"  ID:strid]) {
                    NSLog(@"加载数据出错。");
                }
            }
            
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
    [self performSegueWithIdentifier:@"edit" sender:nil];
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
