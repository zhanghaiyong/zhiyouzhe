//
//  SelectScenicViewController.m
//  Guide
//
//  Created by ksm on 16/4/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SeverTimeViewController.h"
#import "ScenicLayout.h"
#import "SeverTimeCell.h"
//#import "ScenicHead.h"
//#import "NavigationView.h"
#import "CalendarModel.h"

@interface SeverTimeViewController ()

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *dates;

@end

@interface SeverTimeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{

    UICollectionView *collection;
    UIButton         *saveBtn;
    AccountModel     *account;
}

@end

@implementation SeverTimeViewController

-(NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        _dataArray = dataArray;
    }
    return _dataArray;
}

-(NSMutableArray *)dates {
    
    if (_dates == nil) {
        
        NSMutableArray *dates = [NSMutableArray array];
        _dates = dates;
    }
    return _dates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务时间";
    
    [self setNavigationLeft:@"icon_back_iphone"];
    account = [AccountModel account];
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn sizeToFit];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    saveBtn.userInteractionEnabled = NO;
    [saveBtn setTitleColor:lever2Color forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn sizeToFit];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:[[ScenicLayout alloc]init]];
    collection.backgroundColor = [UIColor clearColor];
    collection.dataSource = self;
    collection.delegate = self;
    [collection registerClass:[SeverTimeCell class] forCellWithReuseIdentifier:@"MY_CELL"];//注册item或cell
    collection.alwaysBounceVertical = YES;
    [self.view addSubview:collection];
    
    [self loadSeverTime];
    
}


- (void)loadSeverTime {

    [[HUDConfig shareHUD]alwaysShow];
    NSDictionary *params = @{@"zhiliaoId":account.id,@"token":account.token};
    [KSMNetworkRequest postRequest:KGetCalendar params:params success:^(id responseObj) {
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        NSLog(@"%@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                NSArray *array = [responseObj objectForKey:@"data"];
                NSArray *modelArray = [CalendarModel mj_objectArrayWithKeyValuesArray:array];
                [self.dataArray addObjectsFromArray:modelArray];
                [collection reloadData];
           }
        }
    } failure:^(NSError *error) {
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
    } type:0];
}

- (void)saveAction {

    [[HUDConfig shareHUD]alwaysShow];
    NSLog(@"dates  = %@",self.dates);
    NSString *dateString = [self.dates componentsJoinedByString:@","];
    NSDictionary *params = @{@"zhiliaoId":account.id,@"token":account.token,@"dates":dateString};
    [KSMNetworkRequest postRequest:KNotOderTake params:params success:^(id responseObj) {
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        NSLog(@"%@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:0];
}

- (void)back {

    //通过保存按钮的交互来盘点是否修改了信息，提示信息，是直接退出，还是继续编辑
    if (saveBtn.userInteractionEnabled == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"还未保存，是否退出" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark  CollectionViewDelegate
//返回section数量
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//必须实现，返回每个section中item的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

//必须实现，返回每个item的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeverTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    cell.sender.tag = 100+indexPath.row;
    CalendarModel *model = self.dataArray[indexPath.row];
    NSString *time = [model.time substringFromIndex:5];
    NSString *weel = model.week;
   [cell.sender setTitle:[NSString stringWithFormat:@"%@(%@)",time,weel] forState:UIControlStateNormal];
    cell.time = model.time;                                                                                                                                                        
    if (![model.state isEqualToString:@"可接单日"]) {
        [cell.sender setTitleColor:lever3Color forState:UIControlStateNormal];
        cell.roleImage.hidden = YES;
    }
    
    [cell tapThisCell:^(id c) {
        SeverTimeCell *tapCell = (SeverTimeCell *)c;
        
        if (saveBtn.userInteractionEnabled == NO) {
            
            saveBtn.userInteractionEnabled = YES;
            [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
        }
        
        if (!tapCell.sender.selected) {
            
            [self.dates addObject:tapCell.time];
            
        }else {
            
            if ([self.dates containsObject:tapCell.time]) {
                [self.dates removeObject:tapCell.time];
            }
        }
        
    }];
    
    return cell;
}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    SeverTimeCell *cell = (SeverTimeCell *)[self collectionView:collection cellForItemAtIndexPath:indexPath];
//    if (cell.sender.selected) {
//        [self.dates addObject:cell.time];
//    }else {
//        [self.dates removeObject:cell.time];
//    }
//    
//    NSLog(@"dates = %@",self.dates);
//}


@end
