//
//  tongjiywt.h
//  运维通
//
//  Created by abc on 15/8/27.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tongjiywt : UIViewController< UITableViewDelegate, UITableViewDataSource>{
    
    BOOL _reloading;
    int indexa;
    UIWebView *WebView;
    
}
-(void)genz;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(int *)num:(int *)num2;


@end
