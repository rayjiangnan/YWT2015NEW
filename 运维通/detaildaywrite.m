//
//  detaildaywrite.m
//  运维通
//
//  Created by abc on 15/8/5.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "detaildaywrite.h"
#import "MBProgressHUD+MJ.h"
#import "pinglunCell.h"
#import "pinglunlist.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Extension.h"

@interface detaildaywrite ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    int pagnum;
     NSString *nid;
}
@property (weak, nonatomic) IBOutlet UILabel *bt;
@property (weak, nonatomic) IBOutlet UITextView *nr;
@property (weak, nonatomic) IBOutlet UILabel *pl;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation detaildaywrite
@synthesize strTtile;


-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    [self ChangeItemInit:@"log"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self network];
    self.tableview.scrollEnabled=NO;
    self.scrollview.contentSize=CGSizeMake(320, 830);
    self.tableview.rowHeight=70;
}

-(void)network{
        
    NSString *UserID =[self GetUserID];
    
    NSString *Logid=[NSString stringWithFormat:@"%@",strTtile];
    nid=Logid;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_YWLog.ashx?action=getitem&q0=%@&q1=%@",urlt,UserID,Logid];
    
    NSString *str = @"type=focus-c";
    
  
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:str];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=responseObject;
        
        NSDictionary *dict1=dict[@"ResultObject"];
        NSMutableArray *pliun=[dict1 objectForKey:@"Replys"];
        pagnum=pliun.count;
        [self netwok:pliun];
        [self.tableview reloadData];
        
        
        self.bt.text=dict1[@"Title"];
        self.nr.text=dict1[@"Content"];
        self.pl.text=[NSString stringWithFormat:@"已有%@评论",dict1[@"ReplyNumber"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
        
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"===========%d",pagnum);
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"tg";
    pinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"pinglunCell" owner:nil options:nil] lastObject];
    }
    cell.user.text=dict2[@"RealName"];
    cell.pl.text=dict2[@"ReplyContent"];
    cell.lc.text=[NSString stringWithFormat:@"%@",dict2[@"rowid"]];
    cell.time.text=[self DateFormartString:dict2[@"Create_Date"]];//[objDateformat3 stringFromDate: date3];
    
    if (![dict2[@"UserImg"] isEqual:[NSNull null]]) {
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        //cell.img.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [cell.img setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
        cell.img.layer.cornerRadius = cell.img.frame.size.width /2;
        cell.img.clipsToBounds = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)more:(id)sender {
    [self performSegueWithIdentifier:@"pl" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[pinglunlist class]]) {
        pinglunlist *detai=vc;
        
        [detai setValue:nid forKey:@"strTtile"];
        
    }
    
    
}


@end
