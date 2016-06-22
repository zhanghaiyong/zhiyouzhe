//
//  BaseParams.m
//  Guide
//
//  Created by ksm on 16/5/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "BaseParams.h"

@implementation BaseParams

- (NSString *)id {

    AccountModel *account = [AccountModel account];
    
    if (account) {
    
        _id = account.id;
    }
    return _id;
}

- (NSString *)token {
    
    AccountModel *account = [AccountModel account];
    
    if (account) {
        
        _token = account.token;
    }
    return _token;
}

@end
