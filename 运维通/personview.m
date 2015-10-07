//
//  personview.m
//
//
//  Created by 南江 on 15/5/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "personview.h"
#import "editview.h"
#import "ChineseString.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Extension.h"

@interface personview ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)NSMutableArray *tgs;
@property (nonatomic,strong)NSMutableArray *tgsname;
@property (nonatomic,strong)NSDictionary *siji;
@property (nonatomic,strong)NSDictionary *diaodu;
@property (nonatomic,copy)NSString *idtt;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *tis;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *jiahao;

@end

@implementation personview
@synthesize indexArray;
@synthesize LetterResultArr;


-(void)viewDidAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden=YES;

        [self totalnarray];
        [self.tableview reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *myColorRGB =[self GetUIColor];

    self.navigationController.navigationBar.barTintColor=myColorRGB;

    [self.navigationController.navigationBar setTitleTextAttributes:

    @{NSFontAttributeName:[UIFont systemFontOfSize:17],

    NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.tableview.rowHeight=50;
 

    [self totalnarray];
    [self.tableview reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [indexArray objectAtIndex:section];
    return key;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
   // NSLog(@"title===%@",title);
    return index;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [indexArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.LetterResultArr objectAtIndex:section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    NSLog(@"%@",dict2);
    static NSString *ID = @"tg";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }

    cell.textLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    int index=_tgs.count;
    NSString *namec=[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    for (int i=0; i<index; i++) {
        
        NSString *name=[_tgs objectAtIndex:i][@"RealName"];
        if ([name isEqualToString:namec]) {
            NSString *type=[NSString stringWithFormat:@"%@",[_tgs objectAtIndex:i][@"UserType"]];
            if ([type isEqualToString:@"20"]) {
                  cell.detailTextLabel.text=@"运维人员";
            }else if ([type isEqualToString:@"30"]){
             cell.detailTextLabel.text=@"调度人员";
            }else{
            cell.detailTextLabel.text=@"老板";
            }
            cell.detailTextLabel.backgroundColor=[UIColor grayColor];
            cell.detailTextLabel.textColor=[UIColor whiteColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12.0];
        
            NSString *img2=[NSString stringWithFormat:@"%@",[_tgs objectAtIndex:i][@"UserImg"]];


            //NSString *img2=[NSString stringWithFormat:@"%@%@",urlt,[_tgs objectAtIndex:i][@"UserImg"]];
            
            if (![img2 isEqualToString:@"/Images/defaultPhoto.png"]) {
                
                NSString *img=[NSString stringWithFormat:@"%@%@",urlt,img2];
                NSURL *imgurl=[NSURL URLWithString:img];
                
                [cell.imageView setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
                
            }else{
                UIImage *icon = [UIImage imageNamed:@"icon_tx"];
                CGSize itemSize = CGSizeMake(60, 60);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [icon drawInRect:imageRect];
                
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"---->%@,%d",[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row],indexPath.row);
    
    [self performSegueWithIdentifier:@"edit" sender:nil];
    
    int index=_tgs.count;
    NSString *namec=[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    for (int i=0; i<index; i++) {

        NSString *name=[_tgs objectAtIndex:i][@"RealName"];
        if ([name isEqualToString:namec]) {
             NSString *idt=[_tgs objectAtIndex:i][@"ID"];
           
            [self idt:idt];
        }

    }

}


-(NSMutableArray *)network:(NSMutableArray *)dict
{
        _tgs=dict;
    
    NSMutableArray *array=[NSMutableArray array];
    for (NSDictionary *str in _tgs) {
        if (![str[@"RealName"] isEqual:[NSNull null]]) {
            NSMutableArray *name=str[@"RealName"];
            [array addObject:name];
        }
    }
    [self namec:array];
    NSArray *stringsToSort=_tgsname;
    
    self.indexArray = [ChineseString IndexArray:stringsToSort];
    self.LetterResultArr = [ChineseString LetterSortArray:stringsToSort];
    
    return _tgs;
}

-(NSMutableArray *)namec:(NSMutableArray *)dict
{
    _tgsname=dict;
    return _tgsname;
    
}

- (void)totalnarray{
 
    NSString *myString =[self GetUserID];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getsupuser&q0=%@",urlt,myString];
        
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:@""];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            return ;
        }else{
            NSMutableArray *dictarr=[[json objectForKey:@"ResultObject"] mutableCopy];
            [self network:dictarr];
        }
        [self.tableview.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}




-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_idtt forKey:@"personid"];
    [userDefaults synchronize];
    return _idtt ;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[editview class]]) {
        editview *detai=vc;
       
        [detai setValue:_idtt forKey:@"strTtile"];
    }
}

@end
