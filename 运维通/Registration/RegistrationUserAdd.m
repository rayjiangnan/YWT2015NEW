//
//  RegistrationUserAdd.m
//  YWTIOS
//
//  Created by ritacc on 15/8/9.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "RegistrationUserAdd.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"
#import "RegistrationUserCell.h"
#import <CoreLocation/CoreLocation.h>


@interface RegistrationUserAdd ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    int num;
    CLGeocoder *_geocoder;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (weak, nonatomic) IBOutlet UITextView *addr;


- (IBAction)BtnSaveClick:(id)sender;
@end

@implementation RegistrationUserAdd
@synthesize _locationManager;


-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //[self.view addSubview: self.tableview];
    self.tabBarController.tabBar.hidden=YES;
    
    [self LoadDataList];

    [self.tableview reloadData];
    self.tableview.rowHeight=60;
    
    self._locationManager = [[CLLocationManager alloc] init];
    self._locationManager.delegate = self;
    self._locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _geocoder=[[CLGeocoder alloc]init];
    
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString *lati=[userDefaultes  stringForKey:@"lati"];
//    NSString *longti=[userDefaultes  stringForKey:@"longti"];
//    
//    if (![lati isEqualToString:@""]) {
//        [self getAddressByLatitude2:_locationManager.location.coordinate.latitude longitude:self._locationManager.location.coordinate.longitude];
//    }
    
    [self getAddressByLatitude2:_locationManager.location.coordinate.latitude longitude:self._locationManager.location.coordinate.longitude];
    
    [_locationManager stopUpdatingLocation];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) SetValue {
    NSString *Create_User =[self GetUserID];
    //NSLog(@"%@",Create_User);
    
    //{UserID":"","latitude":"","longitude":"","Position":"坐标转换的位置信息","IMEI":""}
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    NSString *lati=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.latitude];
    NSString *longtitu=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.longitude];
    
    NSString *latitude=lati;
    NSString *longitude=longtitu;
    NSString *Position=[NSString stringWithFormat:@"%@",self.addr.text];
    
    NSUUID *uuid=[UIDevice currentDevice].identifierForVendor;
    NSString *uuidstr=uuid.UUIDString;
    NSString *uuids=[NSString stringWithFormat:@"%@0000",uuidstr];
    
    NSString *IMEI=[NSString stringWithFormat:@"%@",uuids];
    
    [dic setValue:latitude forKey:@"latitude"];
    [dic setValue:longitude forKey:@"longitude"];
    [dic setValue: Position forKey:@"Position"];
    [dic setValue:IMEI forKey:@"IMEI"];
    
    [dic setValue:Create_User forKey:@"UserID"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    return jsonString;
}

- (IBAction)BtnSaveClick:(id)sender {
    
    if (![self.addr.text isEqualToString:@"(null)"]) {
        NSString *jsonString =[self SetValue];
        
        
        NSString *Create_User =  [self GetUserID];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Registration.ashx",urlt];
        NSString *strparameters=[NSString stringWithFormat:@"action=add&q0=%@&q1=%@",jsonString,Create_User];
        NSLog(@"%@",urlStr);
        NSLog(@"%@",strparameters);
        AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:strparameters];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *json=responseObject;
            
            NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
            if ([Status isEqualToString:@"0"]){
                NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
                [MBProgressHUD showError:ReturnMsg];
                NSLog(@"%@",ReturnMsg);
                return;
            }
            else
            {
                [MBProgressHUD showSuccess:@"打卡成功！"];
                [self LoadDataList];
                [self.tableview reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络异常！"];
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
    }else{
    [MBProgressHUD showError:@"地址提交错误！"];
    }
   
}


/*********开始打卡数据************/
-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}

-(void)LoadDataList{
    int indes=-1;
    
    NSString *Create_User =  [self GetUserID];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Registration.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,indes];
    NSLog(@"000000000000-－－%@",urlStr2);
//     self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }
        NSMutableArray *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
        if (dictarr !=nil && dictarr.count >= 10) {
            self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
        else
        {
            self.tableview.footer = nil;
        }
        if(dictarr.count> 0)
        {
            NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
            num=[dict3[@"Registration_ID"] intValue];
        }
        NSLog(@"%@",dictarr);
        [self netwok:dictarr];
        [self.tableview reloadData];
        
        [self.tableview.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}


-(void)loadMoreData
{
   
    NSString *Create_User =  [self GetUserID];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Registration.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,num];
    
     NSLog(@"000000000000-－－%@",urlStr2);
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }

        NSArray *dictarr=[json objectForKey:@"ResultObject"];
        
        if (dictarr !=nil && dictarr.count >= 10) {
            self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
        else
        {
            self.tableview.footer = nil;
        }
        if (dictarr.count>0) {
            NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
            num=[dict3[@"Registration_ID"] intValue];
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"CRegiCell";
    RegistrationUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RegistrationUserCell" owner:nil options:nil] lastObject];
    }
    NSLog(@"%@",dict2[@"Position"]);
    cell.lblWhere.text=[NSString stringWithFormat:@"%@",dict2[@"Position"]];
    cell.lblTime.text=[self DateFormartString:dict2[@"Create_Date"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)getAddressByLatitude2:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        NSDictionary *dict=placemark.addressDictionary;
        
        self.addr.text=[NSString stringWithFormat:@"%@",dict[@"Name"]];
    }];
}


@end
