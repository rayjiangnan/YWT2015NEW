//
//  dianping.m
//  运维通
//
//  Created by abc on 15/8/3.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "dianping.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "diancell.h"
#import "diandetail.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Extension.h"

@interface dianping ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;



@end

@implementation dianping

-(void)viewDidAppear:(BOOL)animated{
    
    
    int chageStatus=[self ChangePageInit:@"log"];
    if (chageStatus==4) {
        [self network2];
        [self.tableview reloadData];
        
    }
    else if (chageStatus==2) {
        
    }
    else if (chageStatus==3) {
        [self ChangeLoad];
    }
    self.tabBarController.tabBar.hidden=YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self repeatnetwork];
    self.tableview.rowHeight=60;
    
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
    static NSString *ID = @"tg";
    diancell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"diancell" owner:nil options:nil] lastObject];
    }
    cell.bt.text=dict2[@"Title"];
    if (![dict2[@"ReplyNumber"] isEqual:[NSNull null]]) {
        cell.pl.text=[NSString stringWithFormat:@"评论%@",dict2[@"ReplyNumber"]];
    }
    
    if (![dict2[@"UserImg"] isEqual:[NSNull null]]) {
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        [cell.img setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        cell.img.layer.cornerRadius = cell.img.frame.size.width *0.4;
        cell.img.clipsToBounds = YES;
    }
    cell.name.text=dict2[@"RealName"];
//    NSString *dt3=dict2[@"Create_Date"];
//    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
//    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
//    // NSLog(@"%@",dt3);
//    NSString * timeStampString3 =dt3;
//    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
//    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
//    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
//    [objDateformat3 setDateFormat:@"yyyy年MM月dd日 hh:mm"];
    cell.time.text=[self DateFormartKey:dict2[@"Create_Date"] FormartKey:@"yyyy年MM月dd日 hh:mm"];//[objDateformat3 stringFromDate: date3];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:@"xiangxi" sender:nil];
}

-(void)network2{
    
    NSInteger indes=-1;
    NSString *myString =[self GetUserID];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_YWLog.ashx?action=getcompanylist&q0=%@&q1=%d",urlt,myString,indes];
 
 
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }else{
            NSMutableArray *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
            if (dictarr !=nil && dictarr.count < 10) {
                self.tableview.footer = nil;
            }
            else if(dictarr.count >=10 && self.tableview.footer == nil)
            {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            if (dictarr.count>0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                num=[dict3[@"AutoID"] intValue];
            }
            [self netwok:dictarr];
            [self.tableview reloadData];
        }
        
        [self.tableview.footer endRefreshing];
        self.tableview.footer.autoChangeAlpha=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
        
//    }];
//    self.tableview.header.autoChangeAlpha = YES;
//    [self.tableview.header beginRefreshing];
    
    
}


-(NSMutableArray *)repeatnetwork{
    self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    return _tgs;
}


-(void) ChangeLoad
{
    int chageid=[self ChangeGetAutoID:_tgs ItemIDKey:@"LogID" AutoIDKey:@"AutoID" key:@"log"]+1;
    [self  loadMoreData: chageid IsChangeAdd:FALSE];
}

-(void)loadMoreData
{
    [self loadMoreData : num IsChangeAdd:true];
}

-(void)loadMoreData :(int) ChageNum IsChangeAdd:(BOOL) _IsChange
{
    
    NSString *myString =[self GetUserID];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_YWLog.ashx?action=getcompanylist&q0=%@&q1=%d",urlt,myString,ChageNum];
    NSLog(@"%@",urlStr);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
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
            else if(dictarr.count >=10 &&  self.tableview.footer == nil)
            {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            if (dictarr.count>0) {
                if (_IsChange) {
                    [_tgs addObjectsFromArray:dictarr];
                    NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                    num=[dict3[@"AutoID"] intValue];
                }
                else
                {
                    NSString *strid=[self ChangeGetChageID:@"log"];
                    if (![self ChangeData:_tgs NewLoadRecords:dictarr ItemIDKey:@"LogID"  ID:strid]) {
                        //NSLog("加载数据出错。%@",);
                    }
                }
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
    if ([vc isKindOfClass:[diandetail class]]) {
        diandetail *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];

        NSString *orderq=rowdata[@"LogID"];
        [detai setValue:orderq forKey:@"strTtile"];


    }
    
}


@end
