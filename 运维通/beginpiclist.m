//
//  beginpiclist.m
//  test2
//
//  Created by 南江 on 15/8/27.
//  Copyright (c) 2015年 南江. All rights reserved.
//

#import "beginpiclist.h"
#import "beginpic.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Extension.h"
#import "ShowStrViewController.h"

@interface beginpiclist ()<UITableViewDataSource,UITableViewDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;

@end

@implementation beginpiclist

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self netWorkRequest2];

    num=0;
    self.tableview.rowHeight=130;
    
    self.tabBarController.tabBar.hidden=YES;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"tg";
    beginpic *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"beginpic" owner:nil options:nil] lastObject];
    }
    cell.orderno.text=[NSString stringWithFormat:@"单号：%@",dict2[@"OrderNo"]];
    
 
    cell.time.text=[self DateFormartMD:dict2[@"CreateDateTime"]];// ][objDateformat3 stringFromDate: date3];
    
    cell.title.text=[NSString stringWithFormat:@"%@",dict2[@"OrderTitle"]];
    NSMutableArray *array=[dict2 objectForKey:@"Files"];
    cell.x2.hidden=YES;
    cell.x1.hidden=YES;
    cell.x3.hidden=YES;
    cell.x4.hidden=YES;
    
    if (array.count>0) {
        NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,[array objectAtIndex:0]];
        NSURL *imgurl=[NSURL URLWithString:img];
//        [cell.x1 setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        [cell.x1 setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];

        cell.x1.hidden=NO;
        NSLog(@"%@",img);
    }
    if (array.count>1) {
        NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,[array objectAtIndex:1]];
        NSURL *imgurl=[NSURL URLWithString:img];
        [cell.x2 setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:rowdata[@"Order_ID"] forKey:@"orderidt"];
    [userDefaults setObject:@"imgviewstartitem" forKey:@"action"];
    
    [userDefaults synchronize];
    
    //[self performSegueWithIdentifier:@"xiangxi" sender:nil];
    NSMutableArray *imageArray=[NSMutableArray arrayWithCapacity:1];
    ShowStrViewController * showVC = [[ShowStrViewController alloc] init];
    showVC.idex = 0;
    NSMutableArray *array=[rowdata objectForKey:@"Files"];
    if (array.count>0) {
        for(int i=0;i<array.count;i++)
        {
            NSString *imgpath=[array objectAtIndex:i];
            imgpath= [imgpath stringByReplacingOccurrencesOfString:@"icon" withString:@""];;
            NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,imgpath];
            [imageArray addObject:img];
        }
    }
    
    showVC.receiveimageArray=imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
    
}


#pragma mark  下拉加载

-(void)loadMoreData
{
   num=num+1;
   
    NSString *Create_User = [self GetUserID];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=imgviewstart&q0=%@&q1=%d",urlt,Create_User,num];
    NSLog(@"---------%@",urlStr2);
    
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
        self.tableview.footer.autoChangeAlpha=YES;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}



#pragma mark  下拉刷新

-(void)netWorkRequest2
{
    
    NSString *myString =[self GetUserID];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=imgviewstart&q0=%@&q1=%d",urlt,myString,num];

    NSLog(@"%@",urlStr2);
         
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
}



@end
