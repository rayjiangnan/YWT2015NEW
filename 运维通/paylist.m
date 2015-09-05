//
//  paylist.m
//  运维通
//
//  Created by abc on 15/9/5.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "paylist.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "paylistcell.h"

@interface paylist ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (weak, nonatomic) IBOutlet UILabel *money;


@end

@implementation paylist
-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self network2];
    [self.tableview reloadData];
    self.tableview.rowHeight=60;
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
    static NSString *ID = @"tg";
    paylistcell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"paylistcell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}


-(void)network2{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_Wallet.ashx?action=getlist&q0=%@&q1=-1",urlt,myString];
    
    NSString *str = @"type=focus-c";
    NSLog(@"++++%@",urlStr);
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:str];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        if (![dict[@"ResultObject"] isEqual:[NSNull null]]) {
            NSDictionary *dict2=dict[@"ResultObject"];
            NSDictionary *dictmoney=[dict2 objectForKey:@"Wallet"];
            self.money.text=[NSString stringWithFormat:@"%@",dictmoney[@"Wallet_Lave"]];
            NSMutableArray *dictarr=[[dict2 objectForKey:@"Records"] mutableCopy];
            if (dictarr.count>0) {
                 NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
            num=[dict3[@"Registration_ID"] intValue];
            
            NSLog(@"%@",dictarr);
            [self netwok:dictarr];
            [self.tableview reloadData];
            NSLog(@"加载数据完成。");
            }
           
     }
        
        [self.tableview.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    
}

@end
