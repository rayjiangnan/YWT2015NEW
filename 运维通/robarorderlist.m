//
//  robarorderlist.m
//  运维通
//
//  Created by ritacc on 15/7/25.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "robarorderlist.h"
#import "listCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "plistcell.h"
#import "plist.h"
#import "UIImageView+WebCache.h"

@interface robarorderlist ()<UITableViewDataSource,UITableViewDelegate>
{
    int parameterNumber;
    int selectnum;
    int pagenum1;
    int pagenum2;
    UIButton *_selectBut;
    UILabel *_scrollLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (nonatomic, strong) NSString *igt;
- (IBAction)didClickAllAction:(id)sender;

- (IBAction)didClickInProgressAction:(id)sender;
- (IBAction)didClickCompletedAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *allBut;


@end

@implementation robarorderlist
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableview.rowHeight=155;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _scrollLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 117, self.view.frame.size.width/2.0, 2)];
    _scrollLabel.backgroundColor=ZJColor(18, 138, 255) ;
    [self.view addSubview:_scrollLabel];
    

    
    int chageStatus=[self ChangePageInit:@"Order"];
    if (chageStatus==1 || chageStatus==4) {
        [self netWorkRequest:0];
        selectnum=1;
        pagenum1=0;
        pagenum2=0;



        indexa=0;
    }
    else if (chageStatus==2) {
        
    }
    else if (chageStatus==3) {
        //[self ChangeLoad];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"plistcell";
    plistcell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"plistcell" owner:nil options:nil] lastObject];
    }

    cell.dh.text=dict2[@"OrderNo"];
    NSString *zt=[NSString stringWithFormat:@"%@",dict2[@"Status_Name"]];

    cell.zt.text=zt;
    if (selectnum==1) {
        cell.zt.hidden=NO;
    }else  if (selectnum==2) {
        cell.zt.hidden=YES;
    }
    
    cell.bt.text=dict2[@"OrderTitle"];
    cell.dz.text=dict2[@"Task_Address"];
    cell.dz.numberOfLines = 0;
    
    
    
    cell.sj.text=[self DateFormartMD:dict2[@"CreateDateTime"]];//[objDateformat3 stringFromDate: date3];
    NSString *xin=[NSString stringWithFormat:@"%@",dict2[@"Stars"]];
    if ([xin isEqualToString:@"5"]) {

    }
    if ([xin isEqualToString:@"4"]) {
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([xin isEqualToString:@"3"]) {

        cell.x4.image=[UIImage imageNamed:@"hxx"];
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([xin isEqualToString:@"2"]) {

        cell.x3.image=[UIImage imageNamed:@"hxx"];
        cell.x4.image=[UIImage imageNamed:@"hxx"];
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([xin isEqualToString:@"1"]) {
      
        cell.x2.image=[UIImage imageNamed:@"hxx"];
        cell.x3.image=[UIImage imageNamed:@"hxx"];
        cell.x4.image=[UIImage imageNamed:@"hxx"];
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    if ([xin isEqualToString:@"0"]) {
        cell.x1.image=[UIImage imageNamed:@"hxx"];
        cell.x2.image=[UIImage imageNamed:@"hxx"];
        cell.x3.image=[UIImage imageNamed:@"hxx"];
        cell.x4.image=[UIImage imageNamed:@"hxx"];
        cell.x5.image=[UIImage imageNamed:@"hxx"];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *img2=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"SuppImg"]];
    NSURL *imgurl=[NSURL URLWithString:img2];
    [cell.img setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img2]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




-(void)netWorkRequest:(int)parameter
{
    NSInteger indes=0;
         _igt=@"0";
        NSString *myString =[self GetUserID];
        NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_OrderPlatform.ashx?action=ywusergetlist&q0=%d&q1=%@",urlt,indes,myString];
    NSLog(@"%@",urlStr);
        NSString *str = @"type=focus-c";
        AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:str];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *dict=responseObject;
            NSMutableArray *dictarr=[dict objectForKey:@"ResultObject"] ;
            if (dictarr !=nil && dictarr.count >= 10) {
                self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            else
            {
                self.tableview.footer = nil;
            }
            _tgs=dictarr;
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD showError:@"网络异常！"];
            
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
}

-(void)netWorkRequest2:(int)parameter
{
    NSInteger indes=0;
    _igt=@"1";
    NSString *myString =[self GetUserID];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_OrderPlatform.ashx?action=applyrecord&q0=%d&q1=%@",urlt,indes,myString];
    NSLog(@"%@",urlStr);
    NSString *str = @"type=focus-c";
    AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:str];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        NSMutableArray *dictarr=[dict objectForKey:@"ResultObject"] ;
        if (dictarr !=nil && dictarr.count >= 10) {
            self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
        else
        {
            self.tableview.footer = nil;
        }
        _tgs=dictarr;
        [self.tableview reloadData];
        [self.tableview.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

-(void)loadMoreData
{
    NSString *urlStr2;
    NSString *myString =[self GetUserID];
    
    if (selectnum==1) {
        pagenum1=pagenum1+1;
         urlStr2= [NSString stringWithFormat:@"%@/api/YWT_OrderPlatform.ashx?action=ywusergetlist&q0=%d&q1=%@",urlt,pagenum1,myString];
    }else  if (selectnum==2) {
        pagenum2=pagenum2+1;
        urlStr2= [NSString stringWithFormat:@"%@/api/YWT_OrderPlatform.ashx?action=applyrecord&q0=%d&q1=%@",urlt,pagenum2,myString];
    }
//    NSLog(@"999999999----%@",urlStr2);
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



- (IBAction)didClickAllAction:(UIButton *)sender {
    
    [self publicMethod:sender];
    parameterNumber=0;
    selectnum=1;
    [UIView animateWithDuration:0.5 animations:^{
     
        _scrollLabel.frame=CGRectMake(0, 117, self.view.frame.size.width/2.0, 2);
        
    }];
    [self netWorkRequest:parameterNumber];
    
}

- (IBAction)didClickInProgressAction:(UIButton *)sender {
    [self publicMethod:sender];
    
    parameterNumber=0;
    selectnum=2;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollLabel.frame=CGRectMake(self.view.frame.size.width/2.0, 117,self.view.frame.size.width/2.0, 2);
        
    }];
    
    [self netWorkRequest2:parameterNumber];
    
}

//- (IBAction)didClickCompletedAction:(UIButton *)sender {
//    [self publicMethod:sender];
//    parameterNumber=2;
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        _scrollLabel.frame=CGRectMake(2*self.view.frame.size.width/2.0, 117, self.view.frame.size.width/3.0, 2);
//        
//    }];
//    [self netWorkRequest:parameterNumber];
//}
-(void)publicMethod:(id)sender{
    [_selectBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:ZJColor(18, 138, 255) forState:UIControlStateNormal];
    
    _selectBut=sender;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"zd" sender:nil];
    
    if (selectnum==1) {
        //cell.zt.hidden=NO;
    }else  if (selectnum==2) {
        //cell.zt.hidden=YES;
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[plist class]]) {
        plist *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"Order_ID"];
        [detai setValue:orderq forKey:@"strTtile"];
        
    }
    
}



@end
