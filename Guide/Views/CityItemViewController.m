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
@interface CityItemViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    UIPageControl    *control;
    UICollectionView *collection;
    UILabel          *titleLabel;
    NSMutableArray   *dataArray;
    NSInteger        numberOfPages;
    UIButton         *currentBtn;
    //绑定的city
    CityModel        *bindCity;
    
}
@end

static NSString * const reuseIdentifier = @"Cell";

@implementation CityItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"服务城市";
    self.view.backgroundColor = backgroudColor;
    
    dataArray = [NSMutableArray array];
    
    UIButton *left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left setTitleColor:lever1Color forState:UIControlStateNormal];
    left.titleLabel.font = lever1Font;
    [left setAction:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [right setTitle:@"确定" forState:UIControlStateNormal];
    [right setTitleColor:lever1Color forState:UIControlStateNormal];
    right.titleLabel.font = lever1Font;
    [right setAction:^{
        self.callBlock(bindCity);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
        
      [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        
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
        }
        }
       
    } failure:^(NSError *error) {
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
    } type:0];
}

- (void)returnBindCity:(CallBlock)block {

    self.callBlock = block;
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
    
    if (indexPath.row == 0) {
        
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
}


@end
