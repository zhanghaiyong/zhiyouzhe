//
//  CityItemViewController.m
//  Guide
//
//  Created by ksm on 16/4/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "CityItemViewController.h"
#import "CellLayout.h"
#import "Cell.h"
#import "CityModel.h"
#import "InfoParams.h"
@interface CityItemViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    
    UIPageControl    *control;
    UICollectionView *collection;
    UILabel          *titleLabel;
    NSMutableArray   *dataArray;
    NSInteger        numberOfPages;
    UIButton         *currentBtn;
    //绑定的city
    CityModel        *bindCity;
    AccountModel *account;
    
}
@property (nonatomic,strong)InfoParams *params;
@end

static NSString * const reuseIdentifier = @"Cell";

@implementation CityItemViewController

-(InfoParams *)params {
    
    if (_params == nil) {
        
        InfoParams *params = [[InfoParams alloc]init];
        _params = params;
    }
    return _params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backgroudColor;
    account = [AccountModel account];
    
    dataArray = [NSMutableArray array];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn sizeToFit];
    [btn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
    [btn setAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:[[CellLayout alloc]init]];
    collection.backgroundColor = [UIColor clearColor];
    collection.dataSource = self;
    collection.delegate = self;
    [collection registerClass:[Cell class] forCellWithReuseIdentifier:reuseIdentifier];//注册item或cell
    collection.alwaysBounceVertical = YES;
    collection.showsHorizontalScrollIndicator = NO;
    collection.bounces = NO;
    collection.pagingEnabled = YES;
    [self.view addSubview:collection];
    
    [self requestCityList];
}

- (void)requestCityList {

    [[HUDConfig shareHUD]alwaysShow];
    
    [KSMNetworkRequest postRequest:KGetCityList params:nil success:^(id responseObj) {
        
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
            for (NSDictionary *m in [responseObj objectForKey:@"data"]) {
                
                CityModel *model = [CityModel mj_objectWithKeyValues:m];
                [dataArray addObject:model];
            }
            
            //有城市列表，默认把第一个设置为绑定状态
            if (dataArray.count > 0) {
               bindCity = dataArray[0];
            }
                
            [collection reloadData];
            }else {
            
                [[HUDConfig shareHUD]ErrorHUD:@"失败" delay:DELAY];
            }
        }
        
        [[HUDConfig shareHUD]dismiss];
       
    } failure:^(NSError *error) {
        [[HUDConfig shareHUD]ErrorHUD:@"失败" delay:DELAY];
    } type:0];
}


#pragma mark UICollectionView代理和数据源
//返回组的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

//返回组的cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return dataArray.count;
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    CityModel *model = dataArray[indexPath.row];
    [cell.itemButton setTitle:model.cityName forState:UIControlStateNormal];
    
    if ([model.cityName isEqualToString:account.serviceCity]) {
        
        cell.itemButton.selected = YES;
        currentBtn = cell.itemButton;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    bindCity = dataArray[indexPath.row];
    
    if (currentBtn != cell.itemButton) {
        
        currentBtn.selected = NO;
        currentBtn = cell.itemButton;
        cell.itemButton.selected = YES;
    }
    
    self.params.cityId = bindCity.id;
    self.params.serviceCity = bindCity.cityName;
    
    FxLog(@"%@",self.params.mj_keyValues);
    
//    [[HUDConfig shareHUD] alwaysShow];
//    [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
//        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
//        FxLog(@"%@",responseObj);
//        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
//            
//            NSDictionary *dic = [responseObj objectForKey:@"data"];
//            
//            if ([dic.allKeys containsObject:@"cityId"]) {
//                account.cityId = [dic objectForKey:@"cityId"];
//            }
//            if ([dic.allKeys containsObject:@"serviceCity"]) {
//                account.serviceCity = [dic objectForKey:@"serviceCity"];
//            }
//            
//            [AccountModel saveAccount:account];
            self.callBlock(bindCity);
            
            [self.navigationController popViewControllerAnimated:YES];
//        }
    
//    } failure:^(NSError *error) {
//        
//        [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
//        
//    } type:2];

}

- (void)returnBindCity:(severCityBlock)block {
    
    self.callBlock = block;
}

@end
