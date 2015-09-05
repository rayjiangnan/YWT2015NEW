//
//  RegistrationComapnyView.m
//  YWTIOS
//
//  Created by ritacc on 15/8/13.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "RegistrationComapnyView.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"
#import "RegistrationComapnyCell.h"



@interface RegistrationComapnyView ()<UITableViewDataSource,UITableViewDelegate>
{
    int num;
    int sem;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segDay;
@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
- (IBAction)btnSearchClick:(id)sender;

@property (nonatomic, strong) NSMutableArray *tgs;

@end

@implementation RegistrationComapnyView

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if (![[userDefaultes stringForKey:@"personname"] isEqualToString:@""]) {

    self.txtUserID.text = [userDefaultes stringForKey:@"personname"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;

   
    [self LoadDataList];
     [self repeatnetwork];
    [self.tableview reloadData];
    self.tableview.rowHeight=75;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

/*********开始打卡数据************/
-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}

- (IBAction)all:(id)sender {
    
    self.txtUserID.text=@"全部";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *kong=@"";
    [userDefaults setObject:kong forKey:@"personID"];
    [userDefaults setObject:kong forKey:@"personname"];
    
    
}


-(void)LoadDataList{
    int indes=-1;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    /*
    YWT_Registration.ashx?action=getcompanylist&q0=&q1=&q2=&q3=	查询员工打卡记录
    q0	操作人ID
    q1	指定运维人员ID
    q2	查询类型： day 当日 7day 7天内 pmonth 上月 cmonth 本月 3month
    q3	最小ID，第一次-1
     */
    sem= self.segDay.selectedSegmentIndex;
    NSString *searchtype=@"day";
    if (sem==0) {
        searchtype=@"day";
    }
    else if(sem==1) {
        searchtype=@"7day";
    }
    else if(sem==2) {
        searchtype=@"cmonth";
    }
    else if(sem==3) {
        searchtype=@"pmonth";
    }
    else if(sem==4) {
        searchtype=@"3month";
    }
    
    NSString *searchUserID=[userDefaultes stringForKey:@"personID"];

    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Registration.ashx?action=getcompanylist&q0=%@&q1=%@&q2=%@&q3=%d"
                         ,urlt,Create_User,searchUserID,searchtype,indes];
    
    NSLog(@"－－－－%@",urlStr2);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict2=responseObject;
         NSMutableArray *dictarr=[[dict2 objectForKey:@"ResultObject"] mutableCopy];
        NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
        num=[dict3[@"Registration_ID"] intValue];
        
        [self netwok:dictarr];
        [self.tableview reloadData];
        NSLog(@"加载数据完成。");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"CregisCell";
    RegistrationComapnyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RegistrationComapnyCell" owner:nil options:nil] lastObject];
    }
    cell.lblUserName.text=[NSString stringWithFormat:@"%@",dict2[@"RealName"]];
    cell.lblAddr.text=[NSString stringWithFormat:@"%@",dict2[@"Position"]];
    cell.lblTime.text=[self DateFormartMDHM:dict2[@"Create_Date"]];
    
    if ([[NSString stringWithFormat:@"%@",dict2[@"UserImg"]] isEqualToString:@"/Images/defaultPhoto.png"]) {
    }else{
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        UIImage *imgUserimg=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [cell.UserImg setImage:imgUserimg];
        
    }
    return cell;
}


-(NSMutableArray *)repeatnetwork{
    
    
    self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    return _tgs;
    
    
}


-(void)loadMoreData
{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    /*
     YWT_Registration.ashx?action=getcompanylist&q0=&q1=&q2=&q3=	查询员工打卡记录
     q0	操作人ID
     q1	指定运维人员ID
     q2	查询类型： day 当日 7day 7天内 pmonth 上月 cmonth 本月 3month
     q3	最小ID，第一次-1
     */
    sem= self.segDay.selectedSegmentIndex;
    NSString *searchtype=@"day";
    if (sem==0) {
        searchtype=@"day";
    }
    else if(sem==1) {
        searchtype=@"7day";
    }
    else if(sem==2) {
        searchtype=@"cmonth";
    }
    else if(sem==3) {
        searchtype=@"pmonth";
    }
    else if(sem==4) {
        searchtype=@"3month";
    }
    
    NSString *searchUserID=[userDefaultes stringForKey:@"personID"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Registration.ashx?action=getcompanylist&q0=%@&q1=%@&q2=%@&q3=%d"
                         ,urlt,Create_User,searchUserID,searchtype,num];
    
    NSLog(@"000000000000-－－%@",urlStr2);
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        NSArray *dictarr=[dict objectForKey:@"ResultObject"];
        if(![dictarr isEqual:[NSNull null]])
        {
            if (dictarr.count>0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                num=[dict3[@"Registration_ID"] intValue];
                [_tgs addObjectsFromArray:dictarr];
                [self.tableview reloadData];
                
            }
        }        [self.tableview.footer endRefreshing];
        self.tableview.footer.autoChangeAlpha=YES;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}



- (IBAction)btnSearchClick:(id)sender {
    [self LoadDataList];
    [self.tableview reloadData];
}
@end
