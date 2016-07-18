//
//  InfoParams.h
//  Guide
//
//  Created by ksm on 16/5/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoParams : BaseParams
{
    
}
//年龄
@property (nonatomic,strong)NSString *age;
//
@property (nonatomic,strong)NSString *auditState;
//车照片
@property (nonatomic,strong)NSString *carUrl;
//城市id
@property (nonatomic,strong)NSString *cityId;
//大学
@property (nonatomic,strong)NSString *college;
//驾照照片
@property (nonatomic,strong)NSString *drivingLicenseUrl;
//头像
@property (nonatomic,strong)NSString *headiconUrl;
//身份证正面
@property (nonatomic,strong)NSString *idcardConsUrl;
//身份证号
@property (nonatomic,strong)NSString *idcardNumber;
//身份证背面
@property (nonatomic,strong)NSString *idcardProsUrl;
//
@property (nonatomic,strong)NSString *identificationState;
//昵称
@property (nonatomic,strong)NSString *nickname;
//手机号
@property (nonatomic,strong)NSString *phone;
//真实姓名
@property (nonatomic,strong)NSString *realName;
//
@property (nonatomic,strong)NSString *serviceCarState;
//服务金额
@property (nonatomic)int serviceCharge;
//服务城市
@property (nonatomic,strong)NSString *serviceCity;
//个性签名
@property (nonatomic,strong)NSString *signature;

//
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *photoPaths;

@end
