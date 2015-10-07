//
//  scus.m
//  运维通
//
//  Created by abc on 15/8/30.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "scus.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "CustomerEidt.h"
#import "CustomerCell.h"

@interface scus ()<UITableViewDataSource,UITableViewDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;


@end

@implementation scus

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;

    self.tableview.rowHeight=60;
    
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
     
    NSString *Create_User  =[self GetUserID];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Customer.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,indes];
    NSLog(@"%@",urlStr2);
//    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        NSString *str = @"type=focus-c";
        AFHTTPRequestOperation *op=  [self POSTurlString:urlStr2 parameters:str];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *json=responseObject;
            NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
            if ([Status isEqualToString:@"0"]){
                NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
                [MBProgressHUD showError:ReturnMsg];
                return ;
            }else{
                NSMutableArray *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
                [self netwok:dictarr];
                [self.tableview reloadData];
            }
            
            [self.tableview.header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD showError:@"网络异常！"];
            
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
        
//    }];
//    self.tableview.header.autoChangeAlpha = YES;
//    [self.tableview.header beginRefreshing];

}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}


-(void)loadMoreData
{
    num=num+1;
    
    NSString *Create_User =[self GetUserID];
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
        self.tableview.footer.autoChangeAlpha=YES;    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
     [userDefaults setObject:@"" forKey:@"detaaddr"];
    [userDefaults synchronize];
    
    [[self navigationController] popViewControllerAnimated:YES];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[CustomerEidt class]]) {
        CustomerEidt *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        if (path == Nil) {
            return;
        }
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"CustomerID"]];
        [detai setValue:orderq forKey:@"strTtile"];
    }
}


@end
