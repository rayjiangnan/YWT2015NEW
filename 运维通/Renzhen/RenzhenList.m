//
//  RenzhenList.m
//  运维通
//
//  Created by ritacc on 15/10/5.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "RenzhenList.h"
#import "RenzhenItemCell.h"
#import "RenzhenItemCompany.h"
#import "RenzhenItemUser.h"

#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "UIImageView+WebCache.h"

@interface RenzhenList ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    int num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;


@end


@implementation RenzhenList



-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    
    
    
    self.tableview.rowHeight=100;
    int chageStatus=[self ChangePageInit:@"Renzhen"];

    if (chageStatus==3) {
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
    static NSString *ID = @"RenzhenItemCell";
    RenzhenItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RenzhenItemCell" owner:nil options:nil] lastObject];
    }
    NSLog(@"%@",dict2[@"RealName"]);
    
  
    cell.RealName.text=dict2[@"RealName"];
    cell.Mobile.text=dict2[@"Mobile"];
    
    //cell.UserImg.text=dict2[@"UserImg"];
    if (![dict2[@"UserImg"] isEqual:[NSNull null]]) {
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
       
        [cell.UserImg setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        cell.UserImg.layer.cornerRadius = cell.UserImg.frame.size.width /2;
        cell.UserImg.clipsToBounds = YES;
        
        
//        CGSize itemSize = CGSizeMake(40, 40);
//        UIGraphicsBeginImageContext(itemSize);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [cell.imageView.image drawInRect:imageRect];
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
//        [cell.UserImg setFrame:CGRectMake(10, 10,29, 29)];
//        cell.UserImg.contentMode= UIViewContentModeScaleAspectFit;
        //        [self.imageView setFrame:CGRectMake(10, 10,29, 29)];
    }
    
    cell.Certify_Time.text=[self DateFormartYMD:dict2[@"Certify_Time"]] ;
    cell.CertifyTypeName.text=dict2[@"CertifyTypeName"];
    cell.Company.text=dict2[@"Company"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)network2{
    NSString *Create_User = [self GetUserID];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_CertifyApproval.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,0];
    
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
    int _pagenum=   0;
    [self  loadMoreData: _pagenum IsChangeAdd:FALSE];
}

-(void)loadMoreData
{
    num++;
    [self loadMoreData : num IsChangeAdd:true];
}

-(void)loadMoreData :(int) ChageNum IsChangeAdd:(BOOL) _IsChange
{
    NSString *Create_User =[self GetUserID];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_CertifyApproval.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,ChageNum];
    
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
                [_tgs addObjectsFromArray:dictarr];
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
    NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
   
   int usertype= [rowdata[@"UserType"] intValue];
    if(usertype ==10)
    {
        [self performSegueWithIdentifier:@"company" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"user" sender:nil];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[RenzhenItemCompany class]]) {
        RenzhenItemCompany *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        if (path == Nil) {
            return;
        }
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"ID"]];
        [detai setValue:orderq forKey:@"UserID"];
    }
    if ([vc isKindOfClass:[RenzhenItemUser class]]) {
        RenzhenItemUser *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        if (path == Nil) {
            return;
        }
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"ID"]];
        [detai setValue:orderq forKey:@"UserID"];
    }

}


@end
