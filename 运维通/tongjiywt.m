//
//  tongjiywt.m
//  运维通
//
//  Created by abc on 15/8/27.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "tongjiywt.h"
#import "tongjiCell.h"
#import "orderModel.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"

@interface tongjiywt ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSInteger rowNumber;
    int parameterNumber;
    UIButton *_selectBut;
    UILabel *_scrollLabel;
    
    int pageNum;
    int  allPageNum;
    int  noDispatchPageNum;
    int  transportPageNum;
    int waitPayPageNum;
    NSString *idts;
    
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSString *idtt;
@property (nonatomic,assign)NSInteger *idtt2;
@property (nonatomic,assign)int *idtt3;
@property NSInteger *idenxx;

@property (weak, nonatomic) IBOutlet UIButton *fanhui;

@property (weak, nonatomic) IBOutlet UILabel *fnum;
@property (weak, nonatomic) IBOutlet UILabel *pfen;

- (IBAction)didClickAllAction:(id)sender;

- (IBAction)didClickNoDispatchAction:(id)sender;

- (IBAction)didClickTransportAction:(id)sender;

- (IBAction)didClickWaitPayAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *all;
/*------------*/

@end

@implementation tongjiywt
@synthesize title;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.tabBarController.tabBar.hidden=NO;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self didClickAllAction:self.all];

    [self netWorkRequest2];
    
    _scrollLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 117, self.view.frame.size.width/4.0, 2)];
    
    _scrollLabel.backgroundColor=ZJColor(18, 138, 255);
    
    [self.view addSubview:_scrollLabel];

    UIColor *myColorRGB =[self GetUIColor];
    
    self.navigationController.navigationBar.barTintColor=myColorRGB;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

      self.tableView.rowHeight=50;
    self.tableView.delegate=self;
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
-(void)didClickBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"tg";
    tongjiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"tongjiCell" owner:nil options:nil] lastObject];
   
    }
    if ([[NSString stringWithFormat:@"%@",dict2[@"rowid"]] isEqualToString:@"1"]) {
        cell.paiimg.hidden=NO;
        cell.paiimg.image=[UIImage imageNamed:@"icon_img_1"];
        cell.pai.text=@"";
    }
    if ([[NSString stringWithFormat:@"%@",dict2[@"rowid"]] isEqualToString:@"2"]) {
        cell.paiimg.hidden=NO;
        cell.paiimg.image=[UIImage imageNamed:@"icon_img_2"];
       cell.pai.text=@"";
    }
    if ([[NSString stringWithFormat:@"%@",dict2[@"rowid"]] isEqualToString:@"3"]) {
        cell.paiimg.hidden=NO;
        cell.paiimg.image=[UIImage imageNamed:@"icon_img_3"];
        cell.pai.text=@"";
    }
  
     cell.pai.text=[NSString stringWithFormat:@"%@",dict2[@"rowid"]];
    if (![dict2[@"RealName"] isEqual:[NSNull null]]) {
       cell.name.text=[NSString stringWithFormat:@"%@",dict2[@"RealName"]];
    }
    cell.danno.text=[NSString stringWithFormat:@"%@",dict2[@"OrderFinishNum"]];
    cell.fen.text=[NSString stringWithFormat:@"%@",dict2[@"ScoreAvg"]];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}








//- (void)tijiao2:(NSString *)t1:(NSString *)t2:(NSString *)t3:(NSString *)t4:(NSString *)t5{
//    
//    NSString *urlStr =[NSString stringWithFormat:@"%@/API/HDL_Order.ashx",urlt] ;
//    
//    NSURL *url = [NSURL URLWithString:urlStr];
//    
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
//    
//    request.HTTPMethod = @"POST";
//    
//    
//    NSString *str = [NSString stringWithFormat:@"action=saveorderflow&q0=%@&q1=100&q2=%@&q3=%@&q4=%@&q5=%@",t1,t2,t3,t4,t5];
//    
//    
//    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        if(data!=nil)
//        {
//            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            
//        }else{
//            [MBProgressHUD showError:@"网络请求出错"];
//            return ;
//        }
//    }];
//    
//    
//}



//-(void)genz2:(UIButton *)sender{
//    [self idt3:sender.tag];
//    [self performSegueWithIdentifier:@"gz" sender:nil];
//}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  }

-(NSInteger *)num{
    
    
    return _idenxx;
}


-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}


-(int *)idt3:(int *)id1{
    _idtt3=id1;
    return _idtt3;
    
}
//#pragma mark  下拉加载
//
//-(NSMutableArray *)repeatnetwork{
//    
//    //   __block int pageNum=0;
//    //  __block  int  allPageNum=0;
//    // __block   int  noDispatchPageNum=0;
//    //  __block  int  transportPageNum=0;
//    // __block   int waitPayPageNum=0;
//    
//    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    
//    // self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//    
//    //}];
//    return _tgs;
//    
//    
//}
//-(void)loadMoreData
//{
//    
//    if(parameterNumber==0)
//    {
//        allPageNum++;
//        pageNum=allPageNum;
//        
//    }else if (parameterNumber==1)
//    {
//        noDispatchPageNum++;
//        pageNum=noDispatchPageNum;
//    }else if (parameterNumber==2)
//    {
//        transportPageNum++;
//        pageNum=transportPageNum;
//    }else
//    {
//        waitPayPageNum++;
//        pageNum=waitPayPageNum;
//    }
//    NSString *myString =[self GetUserID];
//    
//    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=monthviewaadmin&q0=%@&q1=%@",urlt,myString,idts];
//    
//    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSMutableDictionary *dict=responseObject;
//        NSArray *dictarr=[dict objectForKey:@"ResultObject"];
//        if(![dictarr isEqual:[NSNull null]])
//        {
//            [_tgs addObjectsFromArray:dictarr];
//            [self.tableView reloadData];
//        }
//        [self.tableView.footer endRefreshing];
//        self.tableView.footer.autoChangeAlpha=YES;
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@"网络请求出错"];
//    }];
//    [[NSOperationQueue mainQueue] addOperation:op];
//    
//    
//}


#pragma mark  点击按钮请求网络
-(void)netWorkRequest
{
    
    NSString *myString =[self GetUserID];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=monthviewaadmin&q0=%@&q1=%@",urlt,myString,idts];
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }else{
            NSMutableDictionary *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
            NSMutableDictionary *dict3=[dictarr objectForKey:@"Item"];
            
            self.fnum.text=[NSString stringWithFormat:@"%@",dict3[@"OrderFinishNum"]];
            self.pfen.text=[NSString stringWithFormat:@"%@", dict3[@"ScoreAvg"]];
            
            NSMutableArray *array=[dictarr objectForKey:@"Items"];
            self.tgs=array;
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
}
#pragma mark  下拉刷新

-(void)netWorkRequest2
{
    
    NSString *myString =[self GetUserID];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=monthviewaadmin&q0=%@&q1=%@",urlt,myString,idts];
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }else{
            //NSMutableArray *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
            NSMutableDictionary *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
            NSMutableDictionary *dict3=[dictarr objectForKey:@"Item"];
            
            self.fnum.text=[NSString stringWithFormat:@"%@",dict3[@"OrderFinishNum"]];
            self.pfen.text=[NSString stringWithFormat:@"%@", dict3[@"ScoreAvg"]];
            
            NSMutableArray *array=[dictarr objectForKey:@"Items"];
            self.tgs=array;
            [self.tableView reloadData];
        }
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
        
    [[NSOperationQueue mainQueue] addOperation:op];
        
}


- (IBAction)didClickAllAction:(id)sender {
    [self aabb];
    [self publicMethod:sender];
   idts=@"cm";
    [UIView animateWithDuration:0.5 animations:^{
        _scrollLabel.frame=CGRectMake(0, 117, self.view.frame.size.width/4.0, 2);
        
    }];
    
    [self netWorkRequest];
    [self netWorkRequest2];
    
    
}

-(void)publicMethod:(id)sender{
    [_selectBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:ZJColor(18, 138, 255) forState:UIControlStateNormal];
    
    _selectBut=sender;
}
-(void)aabb
{
    pageNum=0;
    allPageNum=0;
    noDispatchPageNum=0;
    transportPageNum=0;
    waitPayPageNum=0;
}


- (IBAction)didClickNoDispatchAction:(id)sender {
    
    [self aabb];
    [self publicMethod:sender];
    
     idts=@"m1";
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollLabel.frame=CGRectMake(self.view.frame.size.width/4.0, 117, self.view.frame.size.width/4.0, 2);
        
    }];
    
    [self netWorkRequest];
    [self netWorkRequest2];
    
}

- (IBAction)didClickTransportAction:(id)sender {
    [self aabb];
    
    [self publicMethod:sender];
    
     idts=@"m2";
    [UIView animateWithDuration:0.5 animations:^{
        _scrollLabel.frame=CGRectMake(2*self.view.frame.size.width/4.0, 117, self.view.frame.size.width/4.0, 2);
        
    }];
    
    [self netWorkRequest];
    [self netWorkRequest2];
    
}

- (IBAction)didClickWaitPayAction:(id)sender {
    [self aabb];
    
    [self publicMethod:sender];
    
     idts=@"m3";
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollLabel.frame=CGRectMake(3*self.view.frame.size.width/4.0, 117, self.view.frame.size.width/4.0, 2);
        
    }];
    
   [self netWorkRequest];
    [self netWorkRequest2];
    
}


@end
