//
//  UpFileSyn.h
//  运维通
//
//  Created by ritacc on 15/10/3.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpFileSyn : NSObject
{
    void (^Success) (NSDictionary *result);
    void (^Failure) (NSError *error);
}
-(void) UpFile:(NSData *) filedata UpURL:(NSString *) _upURL
       Success:(void (^)(NSDictionary *result))success
       Failure:(void (^)(NSError *error))failure;
@end
