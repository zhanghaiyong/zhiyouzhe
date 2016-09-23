//
//  TraverNotesViewController.m
//  Guide
//
//  Created by ksm on 16/4/15.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "TraverNotesViewController.h"
#import "TravelNote.h"
#import "TravelNoteCell.h"
#import "ReleaseTraverViewController.h"
#import "DeleteTravelNoteParams.h"
#import "MWPhotoBrowser.h"
@interface TraverNotesViewController ()

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)DeleteTravelNoteParams *deleteParams;

@end

@implementation TraverNotesViewController
{
    
    AccountModel *account;
}

-(NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        NSMutableArray *dataArray = [NSMutableArray array];
        _dataArray = dataArray;
    }
    return _dataArray;
}

-(DeleteTravelNoteParams *)deleteParams {

    if (_deleteParams == nil) {
        DeleteTravelNoteParams *deleteParams = [[DeleteTravelNoteParams alloc]init];
        deleteParams.zid = account.id;
        deleteParams.ztoken = account.token;
        _deleteParams = deleteParams;
    }
    return _deleteParams;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的游记";
    [self setNavigationLeft:@"icon_back_iphone"];
    [self setNavigationRightTitle:@"发布"];
    account = [AccountModel account];
    
    [self loadTravelData];
    
}

- (void)loadTravelData {

    [[HUDConfig shareHUD] alwaysShow];
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    
    [KSMNetworkRequest getRequest:KGetTravelList params:params success:^(id responseObj) {
        FxLog(@"%@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                
                NSArray *array = [responseObj objectForKey:@"data"];
                NSArray *modelArray = [TravelNote mj_objectArrayWithKeyValuesArray:array];
                [self.dataArray addObjectsFromArray:modelArray];
                
                [self.tableView reloadData];
                
            }else {
            
                [[HUDConfig shareHUD] Tips:@"暂未发布游记" delay:DELAY];
            }
        }
        
        [[HUDConfig shareHUD] dismiss];
        
    } failure:^(NSError *error) {
        [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
    } type:0];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    
    TravelNoteCell *cell = [[TravelNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.tag = indexPath.row + 100;
    [cell deleteCell:^(NSInteger cellTag) {
        
        [self deleteTravel:cellTag-100];
    }];
    
    [cell browserImages:^(NSArray *imageVs, NSInteger flag) {
        
        NSMutableArray *showPhotos = [NSMutableArray array];
        for (int i = 0; i<imageVs.count; i++) {
            
            UIImageView *imageV = [cell.contentView viewWithTag:i+100];
            MWPhoto *p = [[MWPhoto alloc]initWithImage:imageV.image];
            [showPhotos addObject:p];
        }
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithPhotos:showPhotos];
        browser.displayActionButton = NO; // 分享按钮
        browser.displayNavArrows = NO; // 是否在工具栏显示左和右导航箭头 (defaults to NO)
        browser.alwaysShowControls = NO ; // 一直显示导航栏
        [browser setCurrentPhotoIndex:flag-100];
        [self.navigationController pushViewController:browser animated:YES];
        
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    TravelNoteCell *cell = (TravelNoteCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)deleteTravel:(NSInteger)celltag {

    TravelNote *model = self.dataArray[celltag];
    self.deleteParams.id = model.id;
    
    [KSMNetworkRequest postRequest:KDeleteTravel params:self.deleteParams.mj_keyValues success:^(id responseObj) {
        FxLog(@"删除游记 ＝ %@",responseObj);
        
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
            [[HUDConfig shareHUD] SuccessHUD:@"删除成功"  delay:DELAY];
            [self.tableView beginUpdates];
            [self.dataArray removeObjectAtIndex:celltag];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:celltag inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
        }else {
        
            [[HUDConfig shareHUD] ErrorHUD:@"删除失败"  delay:DELAY];
        }
        
        
    } failure:^(NSError *error) {
        
    } type:0];
}

- (void)doRight:(UIButton *)sender {
 
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
    ReleaseTraverViewController *releaseTraver = [storyboard instantiateViewControllerWithIdentifier:@"ReleaseTraverViewController"];
    [releaseTraver addNewTravelNote:^(id model) {
        
        [self.tableView beginUpdates];
        [self.dataArray insertObject:model atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }];
    [self.navigationController pushViewController:releaseTraver animated:YES];
    
}

@end
