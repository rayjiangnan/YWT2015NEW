//
//  WarehouseListController.m
//  znar
//
//  Created by ritacc on 15/8/6.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "WarehouseListController.h"
#import "WarehouseCellTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "WarehouseAdd.h"


@interface WarehouseListController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;


@end


@implementation WarehouseListController



-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    
    

    self.tableview.rowHeight=60;
    int chageStatus=[self ChangePageInit:@"Warehouse"];
    if (chageStatus==4) {
        [self network2];
        [self.tableview reloadData];
    }
    else if (chageStatus==2) {
        
    }
    else if (chageStatus==3) {
        [self ChangeLoad];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;
    [self network2];
    [self.tableview reloadData];
    self.tableview.rowHeight=60;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"CellTableViewCell";
    WarehouseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"WarehouseCellTableViewCell" owner:nil options:nil] lastObject];
    }
    NSLog(@"%@",dict2[@"Prodeuct_Model"]);
    
    cell.ProductName.text= [NSString stringWithFormat:@"%@",dict2[@"Prodeuct_Name"]];;
//    cell.Brand.text= [NSString stringWithFormat:@"%@",dict2[@"Product_Brand"]];
//    cell.Model.text= [NSString stringWithFormat:@"%@",dict2[@"Prodeuct_Model"]];
    cell.Number.text= [NSString stringWithFormat:@"%@ %@",dict2[@"Number"],dict2[@"Unit"]];
     
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)network2{

    int indes=-1;
    
    NSString *Create_User = [self GetUserID];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Warehouse.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,indes];
    
    NSLog(@"------%@",urlStr2);
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
            
            if (dictarr.count > 0) {
                NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                num=[dict3[@"Warehouse_ID"] intValue];
            }
            
            [self netwok:dictarr];
            [self.tableview reloadData];

            [self.tableview.header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];

}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}

-(void) ChangeLoad
{
    NSString *strid=[self ChangeGetChageID:@"Warehouse"];
    int _pagenum=   [strid intValue];
    if (_pagenum >=0) {
        [self  loadMoreData: _pagenum+1 IsChangeAdd:FALSE];
    }
}

-(void)loadMoreData
{
    
    [self loadMoreData : num IsChangeAdd:true];
}

-(void)loadMoreData :(int) ChageNum IsChangeAdd:(BOOL) _IsChange
{
    NSString *Create_User =[self GetUserID];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Warehouse.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,ChageNum];

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
            
            if (dictarr.count>0) {
                if (_IsChange) {
                    NSDictionary *dict3=[dictarr objectAtIndex:[dictarr count]-1];
                    num=[dict3[@"Warehouse_ID"] intValue];
                    
                    [_tgs addObjectsFromArray:dictarr];
                }
                else
                {
                    NSString *strid=[self ChangeGetChageID:@"Warehouse"];
                    if (![self ChangeData:_tgs NewLoadRecords:dictarr ItemIDKey:@"Warehouse_ID"  ID:strid]) {
                        NSLog(@"加载数据出错。");
                    }
                }
            }
            [self.tableView reloadData];
        }
        [self.tableView.footer endRefreshing];
        self.tableView.footer.autoChangeAlpha=YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"edit" sender:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[WarehouseAdd class]]) {
        WarehouseAdd *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        if (path == Nil) {
            return;
        }
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"Warehouse_ID"]];
        [detai setValue:orderq forKey:@"strTtile"];
    }
}


@end
