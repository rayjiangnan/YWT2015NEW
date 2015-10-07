//
//  RenzhenItemCell.h
//  运维通
//
//  Created by ritacc on 15/10/5.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenzhenItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *RealName;
@property (weak, nonatomic) IBOutlet UILabel *Mobile;
@property (weak, nonatomic) IBOutlet UIImageView *UserImg;

@property (weak, nonatomic) IBOutlet UILabel *Certify_Time;
@property (weak, nonatomic) IBOutlet UILabel *CertifyTypeName;
@property (weak, nonatomic) IBOutlet UILabel *Company;
@end
