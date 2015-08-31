//
//  imgdetal.m
//  运维通
//
//  Created by abc on 15/8/30.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "imgdetal.h"
#import "MBProgressHUD+MJ.h"
#import"MBProgressHUD+MJ.h"
#import"ShowViewController.h"

@interface imgdetal ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *gt;
@property (nonatomic,strong)NSArray *tgs;
@property (nonatomic,strong)NSString *idtt;
@property (nonatomic,strong)NSString *idtt2;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UIImageView *img6;
@property (weak, nonatomic) IBOutlet UIImageView *img7;
@property (weak, nonatomic) IBOutlet UIImageView *img8;
@property (weak, nonatomic) IBOutlet UIImageView *img9;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *viewhi;
@property (nonatomic,strong)NSMutableArray *imageArray;


@end

@implementation imgdetal
@synthesize strTtile;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray=[NSMutableArray arrayWithCapacity:1];
    
       [self network];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}
-(NSString *)idt2:(NSString *)id2{
    _idtt2=id2;
    return _idtt2 ;
}


-(NSArray *)network{
    NSString *orderid ;

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    orderid = [userDefaultes stringForKey:@"orderidt"];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=imgviewenditem&q0=%@&q1=%@",urlt,orderid,myString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"%@",urlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"type=focus-c";//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(received!=nil){
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dict2=[dict objectForKey:@"ResultObject"];
        
        NSMutableArray *dictarr2=[dict2 objectForKey:@"Files"];
 
        
        if (dictarr2.count>0) {
            _tgs=dictarr2;
 
            
            NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:0]];
            NSURL *imgurl=[NSURL URLWithString:img];
            self.img1.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
            [_imageArray addObject:self.img1.image];
            
            if (dictarr2.count>1) {
            NSString *img2=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:1]];
                NSURL *imgurl2=[NSURL URLWithString:img2];
                self.img2.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl2]];
                [_imageArray addObject:self.img2.image];
                
            }
            
            if (dictarr2.count>2) {
             NSString *img3=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:2]];
                NSURL *imgurl3=[NSURL URLWithString:img3];
                self.img3.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl3]];
                [_imageArray addObject:self.img3.image];
                
            }
            if (dictarr2.count>3) {
              NSString *img4=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:3]];
                NSURL *imgurl4=[NSURL URLWithString:img4];
                self.img4.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl4]];
                [_imageArray addObject:self.img4.image];
                
            }
            if (dictarr2.count>4) {
               NSString *img5=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:4]];
                NSURL *imgurl5=[NSURL URLWithString:img5];
                self.img5.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl5]];
                [_imageArray addObject:self.img5.image];
                
            }
            if (dictarr2.count>5) {
           NSString *img6=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:5]];
                NSURL *imgurl6=[NSURL URLWithString:img6];
                self.img6.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl6]];
                [_imageArray addObject:self.img6.image];
                
            }
            if (dictarr2.count>6) {
                NSString *img7=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:6]];
                NSURL *imgurl7=[NSURL URLWithString:img7];
                self.img7.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl7]];
                [_imageArray addObject:self.img7.image];
                
            }
            if (dictarr2.count>7) {
               NSString *img8=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:7]];
                NSURL *imgurl8=[NSURL URLWithString:img8];
                self.img8.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl8]];
                [_imageArray addObject:self.img8.image];
                
            }
            if (dictarr2.count>8) {
      NSString *img9=[NSString stringWithFormat:@"%@/%@",urlt,[dictarr2 objectAtIndex:8]];
                NSURL *imgurl9=[NSURL URLWithString:img9];
                self.img9.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl9]];
                [_imageArray addObject:self.img9.image];
                
            }
            
            
        }
        
        
        return _tgs;
        
    }else
    {
        [MBProgressHUD showError:@"网络请求出错"];
        return nil;
    }
}


- (IBAction)btn1:(UIButton *)sender {
    
    sender.tag=100;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
    
}

- (IBAction)btn2:(UIButton *)sender {
    
    sender.tag=101;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
    
}

- (IBAction)btn3:(UIButton *)sender {
    sender.tag=102;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
}
- (IBAction)btn4:(UIButton *)sender {
    
    sender.tag=103;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)btn5:(UIButton *)sender {
    sender.tag=104;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)btn6:(UIButton *)sender {
    sender.tag=105;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];}
- (IBAction)btn7:(UIButton *)sender {
    sender.tag=106;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
}
- (IBAction)btn8:(UIButton *)sender {
    
    sender.tag=107;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
}
- (IBAction)btn9:(UIButton *)sender {
    
    sender.tag=108;
    
    ShowViewController * showVC = [[ShowViewController alloc] init];
    showVC.idex = sender.tag;
    
    showVC.receiveimageArray=self.imageArray;
    [self.navigationController pushViewController:showVC animated:YES];
}



-(void)imgview:(NSString *)imgstring{
    self.viewhi.hidden=NO;
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    NSURL *imgurl=[NSURL URLWithString:imgstring];
    self.img.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
    
}

- (IBAction)fanhui:(id)sender {
    self.viewhi.hidden=YES;
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
}


@end
