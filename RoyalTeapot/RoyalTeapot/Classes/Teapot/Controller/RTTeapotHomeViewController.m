//
//  RTTeapotHomeViewController.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "RTTeapotHomeViewController.h"
#import "RTHomeCollectionViewCell.h"
#import "RTMenuViewController.h"
#import "RTMQTTResultDataModel.h"
#import "RTTeapotHomeCenterBtnView.h"
#import "DeviceStatusCodeModel.h"
#import <AddDeviceViewController.h>
#import <MQTTSession.h>

@interface RTTeapotHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MQTTSessionDelegate>
{
    deviceStatus _status;
    MQTTSession *_secction;
    NSInteger _currentPage;
    NSMutableDictionary *_MQTTParamsDict; //MQTT 推送的设备信息
}

/*** 首页的CollectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/*** 当前控制的设备信息，保存到单例中，发送指令的时候使用 */
@property (nonatomic,strong) SkywareDeviceInfoModel *currentDeviceInfo;
/*** 控制Button */
@property (weak, nonatomic) IBOutlet RTTeapotHomeCenterBtnView *controlBtnView;
/***  分页的View*/
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;
/*** 配置网络/开关机按钮 */
@property (weak, nonatomic) IBOutlet UIButton *teapotCenterBtn;
/*** 用户所有设备的Array */
@property (nonatomic,strong) NSMutableArray *dataList;
/*** 记录查询出的设备信息 */
@property (nonatomic,strong) SkywareResult *result;

@end

@implementation RTTeapotHomeViewController

static NSString *ID = @"HomeCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.hidden = YES;
    [self setUpMenuBtn];
    [self registerCollectionNib];
    [kNotificationCenter addObserver:self selector:@selector(getUserAllDevice) name:kApplicationDidBecomeActive object:nil];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserAllDevice];
}

- (void)getUserAllDevice
{
    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        self.result = result;
        self.dataList = [SkywareDeviceInfoModel objectArrayWithKeyValuesArray:result.result];
        if (self.dataList.count > 1) { // 大于1才显示分页
            self.pageView.hidden = NO;
            self.pageView.numberOfPages = self.dataList.count;
        }
        self.currentDeviceInfo = self.dataList.count ?[self.dataList firstObject]:nil;
        [self updateAllStatus];
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        if ([result.message isEqualToString:@"404"]) {
            [SVProgressHUD dismiss];
            // 停用 MQTT
            [_secction close];
            // 无设备
            _status = notDevice;
            [self.dataList removeAllObjects];
            [self setTeapotCenterBtnWithStatus:notDevice];
            SkywareDeviceInfoModel *model = [[SkywareDeviceInfoModel alloc] init];
            model.device_online = @"3";
            [self.dataList addObject:model];
            [self.collectionView reloadData];
            self.controlBtnView.deviceInfo = model;
        }
    }];
}

/**
 *  更新用户拥有设备的更新
 */
- (void) updateAllStatus
{
    // 更新按钮状态
    [self updateBtnStatus];
    // 订阅MQTT
    [self connectMQTTWithMAC:[_currentDeviceInfo device_mac]];
}


// 订阅MQTT
- (void)connectMQTTWithMAC:(NSString *) mac
{
    // 订阅MQTT
    UIDevice *device = [[UIDevice alloc] init];
    _secction = [[MQTTSession alloc] initWithClientId:device.identifierForVendor.UUIDString];
    [_secction setDelegate:self];
    [_secction connectAndWaitToHost:kMQTTServerHost port:1883 usingSSL:NO];
    [_secction subscribeToTopic:kTopic(mac) atLevel:MQTTQosLevelAtLeastOnce];
}

// 更新按钮状态
- (void)updateBtnStatus
{
    DeviceStatusCodeModel *code = [DeviceStatusCodeModel objectWithKeyValues:_currentDeviceInfo.device_data];
    
    if (![_currentDeviceInfo.device_online integerValue]) { // 离线状态
        _status = offLine;
        [self setTeapotCenterBtnWithStatus:offLine];
    }else{
        if ([code.p boolValue]) { // 开机状态
            _status = standby;
            [self setTeapotCenterBtnWithStatus:standby];
        }else{ // 关机状态
            _status = powerOff;
            [self setTeapotCenterBtnWithStatus:powerOff];
        }
    }
    
    // 更新首页控制按钮
    self.controlBtnView.time = self.result.time;
    self.controlBtnView.deviceInfo = _currentDeviceInfo;
    
    // 更新设备首页显示
    RTHomeCollectionViewCell *collectionViewCell =  [self getCollectionCurrentCell];
    if (collectionViewCell) {
        collectionViewCell.deviceInfo = _currentDeviceInfo;
    }
}

/**
 *  设置首页按钮展示样式
 */
- (void) setTeapotCenterBtnWithBackgroundImageName:(NSString *)imageName AndHighlightedName:(NSString *) highlightedName
{
    [self.teapotCenterBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.teapotCenterBtn setBackgroundImage:[UIImage imageNamed:highlightedName] forState:UIControlStateHighlighted];
}

/**
 *  更新首页按钮展示：（添加设备/配置设备/开机/关机）
 */
- (void)setTeapotCenterBtnWithStatus:(deviceStatus)status
{
    if (status == offLine) {
        [self setTeapotCenterBtnWithBackgroundImageName:@"btn_ctrl_wifi_normal" AndHighlightedName:@"btn_ctrl_wifi_pressed"];
    }else if (status == standby){
        [self setTeapotCenterBtnWithBackgroundImageName:@"power_on_normal" AndHighlightedName:@"power_on_select"];
    }else if (status == powerOff){
        [self setTeapotCenterBtnWithBackgroundImageName:@"power_off_normal" AndHighlightedName:@"power_off_select"];
    }else if(status == notDevice){
        [self setTeapotCenterBtnWithBackgroundImageName:@"add_device_normal" AndHighlightedName:@"add_device_select"];
    }
}

/**
 *  添加菜单按钮
 */
- (void) setUpMenuBtn
{
    BlockButton *btn = [BlockButton newAutoLayoutView];
    btn.ClickOption = ^{
        RTMenuViewController *nemuController = [[RTMenuViewController alloc] init];
        [self.navigationController pushViewController:nemuController animated:YES];
    };
    [btn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn autoSetDimensionsToSize:CGSizeMake(40, 20)];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
}

#pragma mark - CollectionViewDelegate / DataSource

- (void) registerCollectionNib
{
    UINib *xib = [UINib nibWithNibName:@"RTHomeCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:xib forCellWithReuseIdentifier:ID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTHomeCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    collectionViewCell.deviceInfo = self.dataList[indexPath.row];
    return collectionViewCell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算当前页数
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (page != _currentPage) {
        _currentPage = page;
        self.pageView.currentPage = page;
        if (self.dataList.count > page) {
            [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
                self.result = result;
                self.dataList = [SkywareDeviceInfoModel objectArrayWithKeyValuesArray:result.result];
                self.currentDeviceInfo = self.dataList.count ? self.dataList[page]:nil;
                [self updateAllStatus];
                [self.collectionView reloadData];
                [SVProgressHUD dismiss];
                [kNotificationCenter postNotificationName:kScrollHomeViewRemoveLabel object:nil];
            } failure:^(SkywareResult *result) {
                
            }];
        }
    }
}

#pragma mark - MQTT ----Delegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid
{
    [self MQTTUpdateDeviceInfoWithData:data];
    
}

- (void)MQTTUpdateDeviceInfoWithData:(NSData *)data
{
    
    _MQTTParamsDict = [NSMutableDictionary dictionary];
    [_MQTTParamsDict setValue:data forKey:[NSString stringWithFormat:@"%ld",_currentPage]];
    
    SkywareMQTTModel *model = [SkywareMQTTTool conversionMQTTResultWithData:data];
    RTMQTTResultDataModel *deviceCode = [RTMQTTResultDataModel objectWithKeyValues:model.dataDictionary];
    
    // 更新首页开关按钮展示
    if (!model.device_online) { // 离线状态
        _status = offLine;
        [self setTeapotCenterBtnWithStatus:offLine];
    }else{
        if ([deviceCode.p integerValue]) { // 开机状态
            _status = standby;
            [self setTeapotCenterBtnWithStatus:standby];
        }else{ // 关机状态
            _status = powerOff;
            [self setTeapotCenterBtnWithStatus:powerOff];
        }
    }
    
    // 更新首页控制按钮
    self.controlBtnView.dataModel = model;
    
    //    NSLog(@"%@",model.dataDictionary);
    
    // 更新设备首页显示
    RTHomeCollectionViewCell *collectionViewCell =  [self getCollectionCurrentCell];
    if (collectionViewCell) {
        collectionViewCell.dataModel = model;
    }
}

/**
 *  获取当前显示的CollectionViewCell
 */
- (RTHomeCollectionViewCell *)getCollectionCurrentCell
{
    RTHomeCollectionViewCell *collectionViewCell = (RTHomeCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageView.currentPage inSection:0]];
    return collectionViewCell;
}

#pragma mark - 按钮点击

/**
 *  点击了添加设备/配置设备/开关 按钮
 */
- (IBAction)teapotCenterBtnClick:(UIButton *)sender {
    if (_status == offLine) {
        // 设备离线，去配置网络
        AddDeviceViewController *deviceVC = [[AddDeviceViewController alloc] init];
        deviceVC.isAddDevice = NO;
        [self.navigationController pushViewController:deviceVC animated:YES];
    }else if (_status == powerOff){
        // 执行开机操作
        [SkywareDeviceManagement DevicePushCMDWithData:@[@"p::1"]];
    }else if (_status == standby){
        // 执行关机机操作
        [SkywareDeviceManagement DevicePushCMDWithData:@[@"p::0"]];
    }else{
        // 添加设备操作
        AddDeviceViewController *deviceVC = [[AddDeviceViewController alloc] init];
        deviceVC.isAddDevice = YES;
        [self.navigationController pushViewController:deviceVC animated:YES];
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

/**
 *  监听设置新的设备
 */
- (void)setCurrentDeviceInfo:(SkywareDeviceInfoModel *)currentDeviceInfo
{
    _currentDeviceInfo = currentDeviceInfo;
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    instance.device_id = currentDeviceInfo.device_id;
}

@end
