//
//  BasePullTableViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BasePullTableViewController.h"

@interface BasePullTableViewController()

@end

@implementation BasePullTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MJRefreshNormalHeader *headRefresh =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    MJRefreshAutoNormalFooter *footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.header = headRefresh;
    self.tableView.footer = footerRefresh;
}

- (void) loadNewData
{
  
}

- (void)loadMoreData
{
    
}


@end
