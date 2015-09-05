//
//  renzhen.m
//  运维通
//
//  Created by abc on 15/9/5.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "renzhen.h"

@interface renzhen ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *personpasspoart;
@property (weak, nonatomic) IBOutlet UITextField *carno;
@property (weak, nonatomic) IBOutlet UITextField *carlenth;

@property (weak, nonatomic) IBOutlet UILabel *warningLab;

@property (weak, nonatomic) IBOutlet UITextField *carstyle;
@property (weak, nonatomic) IBOutlet UITextField *carweight;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@end

@implementation renzhen

- (void)viewDidLoad {
    [super viewDidLoad];
self.scrollview.contentSize=CGSizeMake(320, 1000);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
