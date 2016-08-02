//
//  AccountModel.m
//  Guide
//
//  Created by ksm on 16/5/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder  encodeObject:_age forKey:@"age"];
    [aCoder encodeObject:_auditState forKey:@"auditState"];
    [aCoder encodeObject:_carUrl forKey:@"carUrl"];
    [aCoder encodeObject:_cityId forKey:@"cityId"];
    [aCoder encodeObject:_college forKey:@"college"];
    [aCoder  encodeObject:_drivingLicenseUrl forKey:@"drivingLicenseUrl"];
    [aCoder encodeObject:_headiconUrl forKey:@"headiconUrl"];
    [aCoder encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_idcardConsUrl forKey:@"idcardConsUrl"];
    [aCoder encodeObject:_idcardNumber forKey:@"idcardNumber"];
    [aCoder  encodeObject:_idcardProsUrl forKey:@"idcardProsUrl"];
    [aCoder encodeObject:_identificationState forKey:@"identificationState"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_realName forKey:@"realName"];
    [aCoder encodeObject:_serviceCarState forKey:@"serviceCarState"];
    [aCoder encodeObject:_serviceCharge forKey:@"serviceCharge"];
    [aCoder encodeObject:_serviceCity forKey:@"serviceCity"];
    [aCoder encodeObject:_signature forKey:@"signature"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_sex forKey:@"sex"];
    [aCoder encodeObject:_photoPaths forKey:@"photoPaths"];
     [aCoder encodeObject:_serviceCarAuth forKey:@"serviceCarAuth"];
    [aCoder encodeObject:_serviceCarCharge forKey:@"serviceCarCharge"];
}

//解的时候调用，告诉系统哪个属性要解档，如何解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        //一定要赋值
        _age = [aDecoder decodeObjectForKey:@"age"];
        _auditState  = [aDecoder decodeObjectForKey:@"auditState"];
        _carUrl = [aDecoder decodeObjectForKey:@"carUrl"];
        _cityId = [aDecoder decodeObjectForKey:@"cityId"];
        _college = [aDecoder decodeObjectForKey:@"college"];
        _drivingLicenseUrl = [aDecoder decodeObjectForKey:@"drivingLicenseUrl"];
        _headiconUrl = [aDecoder decodeObjectForKey:@"headiconUrl"];
        _id = [aDecoder decodeObjectForKey:@"id"];
        _idcardConsUrl = [aDecoder decodeObjectForKey:@"idcardConsUrl"];
        _idcardNumber = [aDecoder decodeObjectForKey:@"idcardNumber"];
        _idcardProsUrl = [aDecoder decodeObjectForKey:@"idcardProsUrl"];
        _identificationState = [aDecoder decodeObjectForKey:@"identificationState"];
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _phone = [aDecoder decodeObjectForKey:@"phone"];
        _realName = [aDecoder decodeObjectForKey:@"realName"];
        _serviceCarState = [aDecoder decodeObjectForKey:@"serviceCarState"];
        _serviceCharge = [aDecoder decodeObjectForKey:@"serviceCharge"];
        _serviceCity = [aDecoder decodeObjectForKey:@"serviceCity"];
        _signature = [aDecoder decodeObjectForKey:@"signature"];
        _token = [aDecoder decodeObjectForKey:@"token"];
        _sex = [aDecoder decodeObjectForKey:@"sex"];
        _photoPaths = [aDecoder decodeObjectForKey:@"photoPaths"];
        _serviceCarAuth = [aDecoder decodeObjectForKey:@"serviceCarAuth"];
        _serviceCarCharge = [aDecoder decodeObjectForKey:@"serviceCarCharge"];
    }
    return self;
}

#pragma mark 保存数据
+ (void)saveAccount:(AccountModel * __nonnull)account {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
    //保存账号信息：数据存储一般我们开发中会搞一个业务类，专门处理数据的存储
    //好处：以后我不想归档，用数据库，直接改业务类
    [Uitils setUserDefaultsObject:data ForKey:Account];
}

#pragma mark  取数据并转模型
+ (AccountModel * __nonnull)account {
    
    NSData *data = [Uitils getUserDefaultsForKey:Account];
    if (data) {
        AccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return account;
    }else {
    
        return nil;
    }

    
}

+ (void)deleteAccount {

    [Uitils UserDefaultRemoveObjectForKey:Account];
}

@end
