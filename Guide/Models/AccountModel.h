//
//  AccountModel.h
//  Guide
//
//  Created by ksm on 16/5/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject<NSCoding>
/**
 *  年龄
 */
@property (nonatomic,strong)NSString *age;
/**
 *  职业
 */
@property (nonatomic,strong)NSString *occupation;
/**
 *  人车合照
 */
@property (nonatomic,strong)NSString *carUrl;
/**
 *  城市id
 */
@property (nonatomic,strong)NSString *cityId;
/**
 *  大学
 */
@property (nonatomic,strong)NSString *college;
/**
 *  学位
 */
@property (nonatomic,strong)NSString *degree;
/**
 *  驾驶证照片
 */
@property (nonatomic,strong)NSString *drivingLicenseUrl;
/**
 *  邮箱
 */
@property (nonatomic,strong)NSString *email;
/**
 *  头像
 */
@property (nonatomic,strong)NSString *headiconUrl;
/**
 *  id
 */
@property (nonatomic,strong)NSString *id;
/**
 *  身份证反面
 */
@property (nonatomic,strong)NSString *idcardConsUrl;
/**
 *  身份证号
 */
@property (nonatomic,strong)NSString *idcardNumber;
/**
 *  身份证正面
 */
@property (nonatomic,strong)NSString *idcardProsUrl;
/**
 *  认证状态
 */
@property (nonatomic,strong)NSString *identificationState;
/**
 *  昵称
 */
@property (nonatomic,strong)NSString *nickname;
/**
 *  手机号
 */
@property (nonatomic,strong)NSString *phone;
/**
 *  qq
 */
@property (nonatomic,strong)NSString *qq;
/**
 *  真实姓名
 */
@property (nonatomic,strong)NSString *realName;
/**
 *  个人介绍
 */
@property (nonatomic,strong)NSString *selfIntroductions;
/**
 *  个人介绍配图
 */
@property (nonatomic,strong)NSString *selfIntroductionsPhoto;
/**
 *  个人城市介绍
 */
@property (nonatomic,strong)NSString *selfcityIntroductions;
/**
 *  个人城市介绍配图
 */
@property (nonatomic,strong)NSString *selfcityIntroductionsPhoto;
/**
 *  个性标签
 */
@property (nonatomic,strong)NSString *selfdomLabel;
/**
 *  个人生活介绍
 */
@property (nonatomic,strong)NSString *selflifeIntroductions;
/**
 *  个人生活介绍配图
 */
@property (nonatomic,strong)NSString *selflifeIntroductionsPhoto;
/**
 *  带车服务审核状态
 */
@property (nonatomic,strong)NSString *serviceCarAuth;
/**
 *  带车服务金额
 */
@property (nonatomic,strong)NSString *serviceCarCharge;
/**
 *  带车服务状态
 */
@property (nonatomic,strong)NSString *serviceCarState;
/**
 *  服务费用
 */
@property (nonatomic,strong)NSString *serviceCharge;
/**
 *  服务城市
 */
@property (nonatomic,strong)NSString *serviceCity;
/**
 *  服务介绍
 */
@property (nonatomic,strong)NSString *servicesIntroductions;
/**
 *  服务介绍配图
 */
@property (nonatomic,strong)NSString *servicesIntroductionsPhoto;
/**
 *  性别
 */
@property (nonatomic,strong)NSString *sex;
/**
 *  个性签名
 */
@property (nonatomic,strong)NSString *signature;
/**
 *  技能标签
 */
@property (nonatomic,strong)NSString *skillLabel;
/**
 *  token
 */
@property (nonatomic,strong)NSString *token;
/**
 *  旅游标签
 */
@property (nonatomic,strong)NSString *travelLabel;
/**
 *  微信
 */
@property (nonatomic,strong)NSString *weixin;
/**
 *  照片
 */
@property (nonatomic,strong)NSString *photoPaths;


+ (void)saveAccount:(AccountModel * __nonnull)account;

+ (AccountModel * __nonnull)account;

+ (void)deleteAccount;

@end
