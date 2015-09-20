//
//  order2ViewController.m
//  送哪儿
//
//  Created by apple on 15/5/1.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "order2ViewController.h"
#import "hjnTG.h"
#import "orderModel.h"
#import "orderdetail.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"

//#import"CbscsController.h"

@interface order2ViewController () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSInteger rowNumber;
    int pagenum;
    int num;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSString *idtt;
@property (nonatomic,assign)NSInteger *idtt2;
@property (nonatomic,assign)int *idtt3;
@property NSInteger *idenxx;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addbtn;


@property (weak, nonatomic) IBOutlet UIButton *fanhui;
@property (weak, nonatomic) IBOutlet UIButton *addbtn1;





@property (weak, nonatomic) IBOutlet UIView *bottomview;


@end

@implementation order2ViewController
@synthesize title;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidLoad];
    
    int chageStatus=[self ChangePageInit:@"Order"];
    if (chageStatus==1 || chageStatus==4) {
        self.navigationController.navigationBar.hidden=NO;
        
        self.tabBarController.tabBar.hidden=NO;
        [self indexchang:self.segmentControl];
        //[self.tableView reloadData];
        [AFNetworkTool netWorkStatus];
        num=0;
    }
    else if (chageStatus==2) {
        
    }
    else if (chageStatus==3) {
        [self ChangeLoad];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *myColorRGB =[self GetUIColor];
    
    self.navigationController.navigationBar.barTintColor=myColorRGB;

    [self.navigationController.navigationBar setTitleTextAttributes:

    @{NSFontAttributeName:[UIFont systemFontOfSize:17],

    NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *pass= [userDefaultes stringForKey:@"passkey"];
    if ([pass isEqualToString:@"pass"]) {
        self.navigationItem.hidesBackButton =YES;
        self.fanhui.hidden=YES;
        
    }else if([pass isEqualToString:@"sjpass"]){
        self.bottomview.hidden=YES;
        self.navigationItem.hidesBackButton =YES;
    }
    [self.tableView reloadData];
    self.tableView.rowHeight=155;
    [self indexchang:self.segmentControl];
    self.tableView.delegate=self;


    NSString *usertype= [userDefaultes stringForKey:@"usertype"];
    if ([usertype isEqualToString:@"20"]) {
        self.addbtn1.hidden=YES;
    }else if([usertype isEqualToString:@"40"]){
     self.addbtn1.hidden=YES;
    }
    [self repeatnetwork];
    indexa=0;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
    hjnTG *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"hjnTG" owner:nil options:nil] lastObject];
    }
    cell.danhao.text=dict2[@"OrderNo"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.biaoti.text=dict2[@"OrderTitle"];
    cell.lxr.text=dict2[@"ContactMan"];
    cell.tel.text=dict2[@"ContactMobile"];
    cell.status.text=dict2[@"Status_Name"];

//    NSString *dt3=dict2[@"CreateDateTime"];;
//    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
//    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
//    // NSLog(@"%@",dt3);
//    NSString * timeStampString3 =dt3;
//    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
//    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
//    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
//    [objDateformat3 setDateFormat:@"MM-dd"];
//    cell.time.text=[objDateformat3 stringFromDate: date3];
    cell.time.text=[self DateFormartMD:dict2[@"CreateDateTime"]];
    
    cell.addr.text=dict2[@"Task_Address"];

//    [cell.btn addTarget:self action:@selector(genz2:) forControlEvents:UIControlEventTouchUpInside];
//    cell.btn.tag =indexPath.row;
//    [cell.contentView addSubview:cell.btn];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];

    [self performSegueWithIdentifier:@"xiangxi" sender:nil];
}






//- (void)tijiao2:(NSString *)t1:(NSString *)t2:(NSString *)t3:(NSString *)t4:(NSString *)t5{
//    
//        NSString *urlStr =[NSString stringWithFormat:@"%@/API/HDL_Order.ashx",urlt] ;
//        
//        NSURL *url = [NSURL URLWithString:urlStr];
//        
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
//        
//        request.HTTPMethod = @"POST";
//        
//        
//        NSString *str = [NSString stringWithFormat:@"action=saveorderflow&q0=%@&q1=100&q2=%@&q3=%@&q4=%@&q5=%@",t1,t2,t3,t4,t5];
//        
//        
//        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
//        
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//            if(data!=nil)
//            {
//                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//            }else{
//                [MBProgressHUD showError:@"网络请求出错"];
//                return ;
//            }
//            
//        }];
//
//    
//}



//-(void)genz2:(UIButton *)sender{
//    [self idt3:sender.tag];
//    [self performSegueWithIdentifier:@"gz" sender:nil];
//}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[orderdetail class]]) {
       orderdetail *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
   
        NSString *orderq=rowdata[@"Order_ID"];
        [detai setValue:orderq forKey:@"strTtile"];
      
    }

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


- (IBAction)indexchang:(UISegmentedControl *)sender {

    NSInteger colum=sender.selectedSegmentIndex;
    pagenum=colum-1;
//    num=-1;
//    [self loadMoreData];
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];

        NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=getlist&q0=0&q1=%@&q2=%d",urlt,myString,pagenum];
        NSURL *url = [NSURL URLWithString:urlStr2];

    NSLog(@"======%@",url);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
        WebView = [[UIWebView alloc] init];
        [WebView setUserInteractionEnabled:NO];
        [WebView setBackgroundColor:[UIColor clearColor]];
        [WebView setDelegate:self];
        [WebView setOpaque:NO];//使网页透明
        [WebView loadRequest:request];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];

        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(received!=nil){
        
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableArray *dictarr=[[dict objectForKey:@"ResultObject"] mutableCopy];
        
        if (dictarr !=nil && dictarr.count < 10) {
            self.tableView.footer = nil;
        }
        else if(dictarr.count >=10 && self.tableView.footer == nil)
        {
            self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
        [self netwok:dictarr];
        [self.tableView reloadData];

    }else
    {
        [MBProgressHUD showError:@"网络请求出错"];
        return ;
    }
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor clearColor]];
    [view setAlpha:0.8];
    [self.view addSubview:view];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [view addSubview:activityIndicator];
    [self.view addSubview:WebView];
    [activityIndicator startAnimating];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
}




-(NSMutableArray *)repeatnetwork{
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    return _tgs;
}
-(void)loadMoreData
{
     num=num+1;
    [self loadMoreData : num IsChangeAdd:true];
}
-(void) ChangeLoad
{
    
    NSString *strid=[self ChangeGetChageID:@"Order"];
    int _pagenum=  [self ChangeNnm:_tgs  ItemIDKey:@"Order_ID"  ID:strid];
    if (_pagenum >=0) {
        [self  loadMoreData: _pagenum IsChangeAdd:FALSE];
    }
    //    -(BOOL) ChangeData:(NSMutableArray *) CRecord NewLoadRecords: (NSMutableArray *) _NewLoadRecords   ItemIDKey:(NSString *) _idkey ID:(NSString *) _id;
    
}
-(void)loadMoreData :(int) ChageNum IsChangeAdd:(BOOL) _IsChange
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
   NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=getlist&q0=%d&q1=%@&q2=%d",urlt,ChageNum,myString,pagenum];
    
    NSLog(@"000000000000-－－%@",urlStr2);
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
           NSMutableArray *dictarr=[[dict objectForKey:@"ResultObject"] mutableCopy];
        if(![dictarr isEqual:[NSNull null]])
        {
            if (dictarr.count < 10) {
                self.tableView.footer = nil;
            }
            else if(dictarr.count >=10 &&  self.tableView.footer == nil)
            {
                self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
            if (dictarr.count>0) {
                if (_IsChange) {
                    [_tgs addObjectsFromArray:dictarr];
                }
                else
                {
                    NSString *strid=[self ChangeGetChageID:@"Order"];
                    if (![self ChangeData:_tgs NewLoadRecords:dictarr ItemIDKey:@"Order_ID"  ID:strid]) {
                        //NSLog("加载数据出错。%@",);
                    }
                }
                [self.tableView reloadData];
            }
        }
        [self.tableView.footer endRefreshing];
        self.tableView.footer.autoChangeAlpha=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}
@end
