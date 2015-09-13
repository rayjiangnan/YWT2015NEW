//
//  beginpiclist.m
//  test2
//
//  Created by 南江 on 15/8/27.
//  Copyright (c) 2015年 南江. All rights reserved.
//

#import "beginpiclist1.h"
#import "beginpic.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"

@interface beginpiclist1 ()<UITableViewDataSource,UITableViewDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;

@end

@implementation beginpiclist1


-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self netWorkRequest2];
    [self repeatnetwork];
    num=0;
    self.tableview.rowHeight=130;
}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    
    _tgs=array;
    return _tgs;
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:rowdata[@"Order_ID"] forKey:@"orderidt"];
    
    [userDefaults synchronize];
    
    [self performSegueWithIdentifier:@"xiangxi" sender:nil];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"tg";
    beginpic *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"beginpic" owner:nil options:nil] lastObject];
    }
    cell.orderno.text=[NSString stringWithFormat:@"单号：%@",dict2[@"OrderNo"]];
    
    NSString *dt3=dict2[@"CreateDateTime"];;
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
 
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"MM-dd"];
    cell.time.text=[objDateformat3 stringFromDate: date3];
    
    cell.title.text=[NSString stringWithFormat:@"%@",dict2[@"OrderTitle"]];
    NSMutableArray *array=[dict2 objectForKey:@"Files"];
    cell.x2.hidden=YES;
    cell.x1.hidden=YES;
    cell.x3.hidden=YES;
    cell.x4.hidden=YES;
    // NSLog(@"--------%@",array[2]);
    if (array.count>0) {
        NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,[array objectAtIndex:0]];
        NSURL *imgurl=[NSURL URLWithString:img];
        [cell.x1 setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        cell.x1.hidden=NO;

        NSLog(@"%@",img);
    }
    if (array.count>1) {
        NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,[array objectAtIndex:1]];
        NSURL *imgurl=[NSURL URLWithString:img];
        [cell.x3 setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        cell.x2.hidden=NO;

    }
    if (array.count>2) {
        NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,[array objectAtIndex:2]];
        NSURL *imgurl=[NSURL URLWithString:img];
        [cell.x3 setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        cell.x3.hidden=NO;

    }
    if (array.count>3) {
        NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,[array objectAtIndex:3]];
        NSURL *imgurl=[NSURL URLWithString:img];
        [cell.x4 setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        cell.x4.hidden=NO;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark  下拉加载

-(NSMutableArray *)repeatnetwork{
    self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    return _tgs;
    
}

-(void)loadMoreData
{
    num=num+1;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=imgviewend&q0=%@&q1=%d",urlt,myString,num];
    NSLog(@"---------%@",urlStr2);
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        if(![[dict objectForKey:@"ResultObject"] isEqual:[NSNull null]])
        {
            NSMutableArray *dictarr=[[dict objectForKey:@"ResultObject"] mutableCopy];
            [_tgs addObjectsFromArray:dictarr];
            [self.tableview reloadData];        }
        [self.tableview.footer endRefreshing];
         self.tableview.footer.autoChangeAlpha=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}



#pragma mark  下拉刷新

-(void)netWorkRequest2
{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=imgviewend&q0=%@&q1=%d",urlt,myString,num];
    
    NSLog(@"000000%@",urlStr2);
        
        NSString *str = @"type=focus-c";
        AFHTTPRequestOperation *op=  [self POSTurlString:urlStr2 parameters:str];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *dict=responseObject;
            if(![[dict objectForKey:@"ResultObject"] isEqual:[NSNull null]])
            {
                NSMutableArray *dictarr=[[dict objectForKey:@"ResultObject"] mutableCopy];
                [self netwok:dictarr];
                [self.tableview reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD showError:@"网络异常！"];
            
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
}


@end
