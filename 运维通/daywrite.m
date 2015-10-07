//
//  daywrite.m
//  运维通
//
//  Created by abc on 15/8/2.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "daywrite.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "dayCell.h"
#import "editdate.h"
#import "detaildaywrite.h"
#import "UIViewController+Extension.h"

@interface daywrite ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;



@end

@implementation daywrite

-(void)viewDidAppear:(BOOL)animated{
    int chageStatus=[self ChangePageInit:@"log"];
    if (chageStatus==4) {
        [self network2];
        [self.tableview reloadData];
        
    }
    else if (chageStatus==2) {
        
    }
    else if (chageStatus==3) {
        //[self ChangeLoad];
    }
    self.tabBarController.tabBar.hidden=YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];

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
    dayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"dayCell" owner:nil options:nil] lastObject];
    }
    cell.bt.text=dict2[@"Title"];
    NSString *LogStatus=[NSString stringWithFormat:@"%@",dict2[@"LogStatus"]];
    if ([LogStatus isEqualToString:@"0"]) {
       cell.pl.text=@"未发布";
        cell.pl.backgroundColor=[UIColor redColor];
    }else{
    if (![dict2[@"ReplyNumber"] isEqual:[NSNull null]]) {
        cell.pl.text=[NSString stringWithFormat:@"评论%@",dict2[@"ReplyNumber"]];
    }
    }

    
    cell.time.text= [self DateFormartKey:dict2[@"Create_Date"] FormartKey:@"yyyy年MM月dd日 hh:mm"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict2=[self.tgs objectAtIndex:[indexPath row]];
    NSString *LogStatus=[NSString stringWithFormat:@"%@",dict2[@"LogStatus"]];
    if ([LogStatus isEqualToString:@"0"]) {
       [self performSegueWithIdentifier:@"write" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"xiangxi" sender:nil];
    }
}

-(void)network2{
    
    NSInteger indes=-1;
    NSString *myString =[self GetUserID];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_YWLog.ashx?action=getlist&q0=%@&q1=%d",urlt,myString,indes];

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
            if (dictarr.count>0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                num=[dict3[@"AutoID"] intValue];
            }
            [self netwok:dictarr];
            [self.tableview reloadData];
        }
         [self.tableview.header endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
}


-(void)loadMoreData
{
    NSString *myString =[self GetUserID];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_YWLog.ashx?action=getlist&q0=%@&q1=%d",urlt,myString,num];
      NSLog(@"++++%@",urlStr);
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        NSArray *dictarr=[dict objectForKey:@"ResultObject"];
        if(![dictarr isEqual:[NSNull null]])
        {
            if (dictarr !=nil && dictarr.count >= 10) {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            else
            {
                self.tableview.footer = nil;
            }
            if (dictarr.count>0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                num=[dict3[@"AutoID"] intValue];
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
    if ([vc isKindOfClass:[editdate class]]) {
        editdate *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"LogID"];
        [detai setValue:orderq forKey:@"strTtile"];
        
    }
    
    if ([vc isKindOfClass:[ detaildaywrite class]]) {
         detaildaywrite *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"LogID"];
        [detai setValue:orderq forKey:@"strTtile"];
        
    }
   
}





@end
