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
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSString *str = @"type=focus-c";
        AFHTTPRequestOperation *op=  [self POSTurlString:urlStr2 parameters:str];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *dict=responseObject;
            if(![[dict objectForKey:@"ResultObject"] isEqual:[NSNull null]])
            {
                NSMutableArray *dictarr=[[dict objectForKey:@"ResultObject"] mutableCopy];
                [self netwok:dictarr];
                [self.tableView reloadData];
            }
            
            [self.tableView.header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD showError:@"网络异常！"];
            
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
        
    }];
    self.tableView.header.autoChangeAlpha = YES;
    [self.tableView.header beginRefreshing];}

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
        NSMutableDictionary *dict=responseObject;
        NSArray *dictarr=[dict objectForKey:@"ResultObject"];
        if(![dictarr isEqual:[NSNull null]])
        {
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
