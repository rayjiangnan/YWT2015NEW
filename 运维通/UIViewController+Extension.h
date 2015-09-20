//
//  UIViewController+Extension.h
//  送哪儿
//
//  Created by pan on 15/7/13.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"AFNetworking.h"
@interface UIViewController (Extension)
-(AFHTTPRequestOperation *)GETurlString:(NSString *)urlString;
-(AFHTTPRequestOperation *)POSTurlString:(NSString *)urlString  parameters:(NSString *)parameters ;

- (BOOL) isBlankString:(NSString *)string;

-(NSString*) DateFormartString:(NSString*) sourcedate;
-(NSString*) DateFormartMDHM:(NSString*) sourcedate;
-(NSString*) DateFormartYMD:(NSString*) sourcedate;
-(NSString*) DateFormartMD:(NSString*) sourcedate;

-(int) ChangePageInit:(NSString *) CKey;
-(void)  ChangeItemInit:(NSString *) CKey;
-(void)  ChangeRecord:(NSString *) chageID key:(NSString *) CKey;
-(void)  ChangeRecordAdd:(NSString *) CKey;
-(NSString *)  ChangeGetChageID :(NSString *) CKey;
//获取刷新数据页数
-(int) ChangeNnm:(NSMutableArray *) Records ItemIDKey:(NSString *) _idkey ID:(NSString *) _id;
-(BOOL) ChangeData:(NSMutableArray *) CRecord NewLoadRecords: (NSMutableArray *) _NewLoadRecords   ItemIDKey:(NSString *) _idkey ID:(NSString *) _id;

-(UIColor*)  GetUIColor;

@end
