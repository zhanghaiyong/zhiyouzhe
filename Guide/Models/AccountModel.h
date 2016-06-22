//
//  AccountModel.h
//  Guide
//
//  Created by ksm on 16/5/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject<NSCoding>
//年龄
@property (nonatomic,strong)NSString *age;
//
@property (nonatomic,strong)NSString *auditState;
@property (nonatomic,strong)NSString *carUrl;
//城市id
@property (nonatomic,strong)NSString *cityId;
//学校
@property (nonatomic,strong)NSString *college;
@property (nonatomic,strong)NSString *drivingLicenseUrl;
//头像
@property (nonatomic,strong)NSString *headiconUrl;
//id
@property (nonatomic,strong)NSString *id;
//身份证正面
@property (nonatomic,strong)NSString *idcardConsUrl;
//身份证号
@property (nonatomic,strong)NSString *idcardNumber;
//身份证反面
@property (nonatomic,strong)NSString *idcardProsUrl;
//认证状态
@property (nonatomic,strong)NSString *identificationState;
//昵称
@property (nonatomic,strong)NSString *nickname;
//手机号
@property (nonatomic,strong)NSString *phone;
//
@property (nonatomic,strong)NSString *realName;
//服务车辆认证
@property (nonatomic,strong)NSString *serviceCarState;
@property (nonatomic,strong)NSString *serviceCarAuth;
@property (nonatomic,strong)NSString *serviceCharge;
//服务城市
@property (nonatomic,strong)NSString *serviceCity;
//个性签名
@property (nonatomic,strong)NSString *signature;
//token
@property (nonatomic,strong)NSString *token;
//性别
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *photoPaths;

+ (void)saveAccount:(AccountModel * __nonnull)account;

+ (AccountModel * __nonnull)account;

+ (void)deleteAccount;

@end
