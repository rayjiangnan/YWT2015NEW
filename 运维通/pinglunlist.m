//
//  pinglunlist.m
//  运维通
//
//  Created by 南江 on 15/9/15.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "pinglunlist.h"
#import "MBProgressHUD+MJ.h"
#import "pinglunCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"

@interface pinglunlist ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    int pagnum;
    int minReplyID;
}
@property (nonatomic, strong) NSMutableArray *tgs;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end


@implementation pinglunlist
@synthesize strTtile;


-(void)viewDidAppear:(BOOL)animated{
    [self ChangeItemInit:@"log"];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        [self repeatnetwork];
    [self network];
    self.tableview.rowHeight=70;
    minReplyID=-1;
}

-(void)network{     
    NSString *CreateUserid  =[self GetUserID];
    
    //NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
 
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_YWLog.ashx?action=getitemreply&q0=%@&q1=%@&q2=-1",urlt,CreateUserid,strTtile];
    
    NSString *str = @"type=focus-c";
    NSLog(@"%@",urlStr);
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:str];
    
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
            if (dictarr.count>0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                minReplyID=[dict3[@"ReplyID"] intValue];
//                [_tgs addObjectsFromArray:dictarr];
//                [self.tableview reloadData];
            }
            [self netwok:dictarr];
            [self.tableview reloadData];
        }
        
        [self.tableview.footer endRefreshing];
        self.tableview.footer.autoChangeAlpha=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
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
    pinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"pinglunCell" owner:nil options:nil] lastObject];
    }
    cell.user.text=dict2[@"RealName"];
    cell.pl.text=dict2[@"ReplyContent"];
    cell.lc.text=[NSString stringWithFormat:@"%@",dict2[@"rowid"]];
    
    cell.time.text=[self DateFormartString:dict2[@"Create_Date"]];//[objDateformat3 stringFromDate: date3];
    
    if (![dict2[@"UserImg"] isEqual:[NSNull null]]) {
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        //cell.img.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [cell.img setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        cell.img.layer.cornerRadius = cell.img.frame.size.width *0.4;
        cell.img.clipsToBounds = YES;
    }
    
    NSLog(@"%@",dict2);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
-(NSMutableArray *)repeatnetwork{
    self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    return _tgs;
}

-(void)loadMoreData
{
    NSString *CreateUserid  =[self GetUserID];
    
    //NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_YWLog.ashx?action=getitemreply&q0=%@&q1=%@&q2=%d",urlt,CreateUserid,strTtile,minReplyID];
    
    NSString *str = @"type=focus-c";
    NSLog(@"%@",urlStr);
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:str];
    
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
            if (dictarr.count>0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                minReplyID=[dict3[@"ReplyID"] intValue];
                [_tgs addObjectsFromArray:dictarr];
                [self.tableview reloadData];
            }
//            [self netwok:dictarr];
//            [self.tableview reloadData];
        }
        [self.tableview.footer endRefreshing];
        self.tableview.footer.autoChangeAlpha=YES;
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

@end
