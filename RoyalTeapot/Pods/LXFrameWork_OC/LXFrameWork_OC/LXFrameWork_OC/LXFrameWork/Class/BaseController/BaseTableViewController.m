//
//  BaseTableViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSLayoutConstraint *_scrollHeight;
}
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tableview -> 从Xib中加载
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]] && view.tag == 0) {
            self.tableView = (UITableView *)view;
            break;
        }
    }
    // xib 中未找到TableView 手动创建
    if (!self.tableView) {
        self.tableView = [UITableView newAutoLayoutView];
        [self.view addSubview:self.tableView];
        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    
    // 设置TableView
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view bringSubviewToFront:self.navView];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellItemGroup *group = self.dataList[indexPath.section];
    BaseCellItem *item = group.item[indexPath.row];
    
    BaseTableViewCell *cell = nil;
    if ([item isKindOfClass:[BaseArrowCellItem class]]) {
        cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleValue1];
    }else if([item isKindOfClass:[BaseSubtitleCellItem class]]){
        cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
    }else{
        cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleDefault];
    }
    cell.items = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 手动取消选中某一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseCellItemGroup *group = self.dataList[indexPath.section];
    BaseCellItem *item = group.item[indexPath.row];
    
    // 如果有block 就执行block 中的操作
    if (item.option) {
        item.option();
        return;
    }
    // 判断是否为箭头样式的cell 操作就是跳转控制器的操作
    if ([item isKindOfClass:[BaseArrowCellItem class]]) {
        BaseArrowCellItem *arrowItem = (BaseArrowCellItem *)item;
        if (arrowItem.detailClass) {
            UIViewController *VC = [[arrowItem.detailClass alloc] init];
            if ([VC isKindOfClass:[BaseViewController class]]) {
                BaseViewController *baseViewController = (BaseViewController *)VC;
                [baseViewController setTitle:item.title];
            }
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
    //    else if ([item isKindOfClass:[BaseSwitchCellItem class]]){
    //        BaseSwitchCellItem *switchCell = (BaseSwitchCellItem *) item;
    //        if (switchCell.switchOption) {
    //            switchCell.switchOption();
    //        }
    //    }
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.headTitle;
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.footerTitle;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.headView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    if (group.headView) {
        return group.headView.height;
    }else if(group.headTitle.length){
        return 23;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    if (group.footerView) {
        return group.footerView.height;
    }else if(group.footerTitle.length){
        return 23;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellItemGroup *group = self.dataList[indexPath.section];
    BaseCellItem *item = group.item[indexPath.row];
    if ([item isKindOfClass:[BaseIconItem class]]) {
        return 70;
    }
    return 44;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如果有下拉图片就方法该图片
    if (self.scaleImage) {
        CGFloat down = -(_scaleHeight) - scrollView.contentOffset.y;
        if (down > 0){
            _scrollHeight.constant = _scaleHeight + down * 5;
        }
    }
    
    if (!_displayNav) return;
    UIColor *NavBackColor = self.navView.backViewBackColor;
    UIColor *blockColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.scaleImage) { // 有下拉图片
        if ((offsetY + _scaleHeight) > 0) {
            CGFloat alpha = 1 - ((100 - (offsetY + _scaleHeight)) / 100);
            [self.navView setScrollNavigationBarBackColor:[NavBackColor colorWithAlphaComponent:alpha]];
            [self.navView setScrollNavigationBarLineBackColor:[blockColor colorWithAlphaComponent:alpha]];
        } else {
            [self.navView setScrollNavigationBarBackColor:[NavBackColor colorWithAlphaComponent:0]];
            [self.navView setScrollNavigationBarLineBackColor:[blockColor colorWithAlphaComponent:0]];
        }
    }else{// 无下拉图片，滚动显示 NavBar
        if (offsetY > 0) {
            CGFloat alpha = 1 - ((100 - offsetY) / 100);
            [self.navView setScrollNavigationBarBackColor:[NavBackColor colorWithAlphaComponent:alpha]];
            [self.navView setScrollNavigationBarLineBackColor:[blockColor colorWithAlphaComponent:alpha]];
        } else {
            [self.navView setScrollNavigationBarBackColor:[NavBackColor colorWithAlphaComponent:0]];
            [self.navView setScrollNavigationBarLineBackColor:[blockColor colorWithAlphaComponent:0]];
        }
    }
}


#pragma mark - Method

/**
 *  实时滚动展示NavigationBar
 */
- (void)setDisplayNav:(BOOL)displayNav
{
    _displayNav = displayNav;
    if (displayNav) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.navView setScrollNavigationBarBackColor:[UIColor clearColor]];
        [self.navView setScrollNavigationBarLineBackColor:[UIColor clearColor]];
    }
}

/**
 *  设置下拉放大图片
 */
- (void)setScaleImage:(UIImage *)scaleImage
{
    _scaleImage = scaleImage;
    self.tableView.contentInset = UIEdgeInsetsMake(_scaleHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -_scaleHeight);
    UIImageView *scralImageView = [UIImageView newAutoLayoutView];
    scralImageView.image = _scaleImage;
    [self.tableView insertSubview:scralImageView atIndex:0];
    [scralImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [scralImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [scralImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    _scrollHeight = [scralImageView autoSetDimension:ALDimensionHeight toSize:_scaleHeight];
    scralImageView.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
