//
//  registperson.m
//  运维通
//
//  Created by abc on 15/8/16.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "registperson.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"

@interface registperson ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *tgs;
@property (nonatomic,strong)NSString *idtt;
@property (nonatomic,strong)NSString *idtt2;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation registperson
@synthesize strTtile;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableview.rowHeight=70;
    [self network];
    _idtt2=[NSString stringWithFormat:@"%@",strTtile];
    NSLog(@"---%@",_idtt2);
    [self idt2:_idtt2];

}




-(NSArray *)network{
    
    NSString *myString =[self GetUserID];
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getsupuser&q0=%@",urlt,myString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"%@",url);
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    
    //第三步，连接服务器
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received!=nil) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        NSArray *dictarr=[dict objectForKey:@"ResultObject"];
        _tgs=dictarr;
    } else{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [MBProgressHUD showError:@"网络请求出错"];
            return ;
        }];
    }
    
    
    
    return _tgs;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"tg";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.imageView.image=[UIImage imageNamed:@"sjtx"];
    
//NSString *img=[NSString stringWithFormat:@"%@",dict2[@"UserImg"]];
    
//NSString *img2=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
    
//    if (![img2 isEqualToString:@"/Images/defaultPhoto.png"]) {
//        
//        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,img2];
//        NSURL *imgurl=[NSURL URLWithString:img];
//        
//        [cell.imageView setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:img]];
//        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width  /2;
//        cell.imageView.clipsToBounds = YES;
//        
//    }else{
//        UIImage *icon = [UIImage imageNamed:@"icon_tx"];
//        CGSize itemSize = CGSizeMake(60, 60);
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [icon drawInRect:imageRect];
//        
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        
//        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width  /2;
//        cell.imageView.clipsToBounds = YES;
//        UIGraphicsEndImageContext();
//
//    }

    
    cell.textLabel.text=dict2[@"RealName"];
    cell.detailTextLabel.text=dict2[@"Mobile"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dicr=[_tgs objectAtIndex:indexPath.row];
    NSString *idr=dicr[@"ID"];
    NSString *name=dicr[@"RealName"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:idr forKey:@"personID"];
    [userDefaults setObject:name forKey:@"personname"];
    
   [[self navigationController] popViewControllerAnimated:YES];
}

-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}
-(NSString *)idt2:(NSString *)id2{
    _idtt2=id2;
    return _idtt2 ;
}


@end
