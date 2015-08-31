//
//  WarehouseListYWUser.m
//  YWTIOS
//
//  Created by ritacc on 15/8/9.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "WarehouseListYWUser.h"
#import "WarehouseCellTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "WarehouseView.h"

#define urlt @"http://ritacc.net"

@interface WarehouseListYWUser ()<UITableViewDataSource,UITableViewDelegate>
{
    int num;

}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@end

@implementation WarehouseListYWUser


-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    [self network2];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self repeatnetwork];
    self.tableview.rowHeight=60;
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
    WarehouseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"WarehouseCellTableViewCell" owner:nil options:nil] lastObject];
    }
    NSLog(@"%@",dict2[@"Prodeuct_Model"]);
    
    cell.ProductName.text= [NSString stringWithFormat:@"%@",dict2[@"Prodeuct_Name"]];;
    cell.Number.text= [NSString stringWithFormat:@"%@ %@",dict2[@"Number"],dict2[@"Unit"]];
    return cell;
}

-(void)network2{
    int indes=-1;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Warehouse.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,indes];
    NSLog(@"%@",urlStr2);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict2=responseObject;
        NSMutableArray *dictarr=[[dict2 objectForKey:@"ResultObject"] mutableCopy];
        NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
        num=[dict3[@"Warehouse_ID"] intValue];
        [self netwok:dictarr];
        [self.tableview reloadData];
         [self.tableView.header endRefreshing];
        NSLog(@"加载数据完成。");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    }];
    self.tableView.header.autoChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
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
 
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Warehouse.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,num];
    NSLog(@"%@",urlStr2);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        NSArray *dictarr=[dict objectForKey:@"ResultObject"];
        if(![dictarr isEqual:[NSNull null]])
        {
            if (dictarr.count>0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                num=[dict3[@"Warehouse_ID"] intValue];
                [_tgs addObjectsFromArray:dictarr];
                [self.tableview reloadData];
                
            }

        }
        [self.tableView.footer endRefreshing];
        self.tableView.footer.autoChangeAlpha=YES;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}





/***数据跳转****/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"view" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[WarehouseView class]]) {
        WarehouseView *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"Warehouse_ID"]];
        [detai setValue:orderq forKey:@"strTtile"];
    }
}



@end
