//
//  JFViewController.m
//  ZCKit
//
//  Created by zjy on 2018/4/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFViewController.h"

#pragma mark - Class JFGestureAgent
@protocol JFGestureAgentProtocol <NSObject>

- (BOOL)agentGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end

@interface JFGestureAgent : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <JFGestureAgentProtocol> delegate;

@end

@implementation JFGestureAgent

- (instancetype)initWithDelegate:(id<JFGestureAgentProtocol>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(agentGestureRecognizer:shouldReceiveTouch:)]) {
        return [self.delegate agentGestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
    return YES;
}

@end



#pragma mark - Class JFViewController
@interface JFViewController () <JFGestureAgentProtocol> {
    void(^_tipTapGesBlock)(void);
}

@property (nonatomic, strong) UILabel *tipBaseLabel;

@property (nonatomic, strong) UIImageView *tipBaseImageView;

@property (nonatomic, strong) UITapGestureRecognizer *keyboardBaseTapGes;

@property (nonatomic, strong) JFGestureAgent *agentBaseTransfer;

@property (nonatomic, assign) BOOL mointerBaseKeyboardTapGes;

@property (nonatomic, assign) BOOL showBaseKeyboard;

@end

@implementation JFViewController

@synthesize bottomAdaptBar = _bottomAdaptBar, topAdaptBar = _topAdaptBar;
@synthesize tableView = _tableView, upload = _upload, request = _request;

- (instancetype)initWithDeliverData:(id)deliverData {
    if (self = [super init]) {
        if (deliverData && [deliverData isKindOfClass:[NSArray class]]) {
            _deliverArr = deliverData;
        } else if (deliverData && [deliverData isKindOfClass:[NSDictionary class]]) {
            _deliverDic = deliverData;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZCWhite;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableViewStyple = UITableViewStyleGrouped;
    self.isInsetAdjustment = YES;
    
    //小金条
    self.view.backgroundColor = ZCRGB(0xF5F5F5);
    [self chageNavigationBgColor];
}



-(void)chageNavigationBgColor{
    //如果是用户操作了新颜认证 需要重新设置导航栏 的背景颜色
    //设置背景颜色渐变
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_NAV)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //[gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#10ACDC"] CGColor],(id)[UIColor colorWithHexString:@"#00D4C7"].CGColor]];//渐变数组
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#FFFFFF"] CGColor],(id)[UIColor colorWithHexString:@"#FFFFFF"].CGColor]];//渐变数组
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = backView.frame;
    [backView.layer addSublayer:gradientLayer];
    [self.navigationController.navigationBar setBackgroundImage:[self convertViewToImage:backView] forBarMetrics:UIBarMetricsDefault];
    
    [self addLeftButtonItemWithImage:@"i_home_back" slected:@"i_home_back"];
}
-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需  要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)addLeftButtonItemWithImage:(NSString *)name slected:(NSString *)nameSelected{
    if (!name && !nameSelected) {
        return;
    }
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([nameSelected isEqualToString:@"title"]) {
        [btnLeft setTitle:name forState:UIControlStateNormal];
        btnLeft.titleLabel.font = kFontSystem(14);
        [btnLeft setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    }else{
        
        [btnLeft setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:nameSelected] forState:UIControlStateSelected];
        [btnLeft setImage:[UIImage imageNamed:nameSelected] forState:UIControlStateHighlighted];
        [btnLeft setFrame:CGRectMake(0, 0, 3 * kMySize(btnLeft.imageView.image.size.width), kMySize(btnLeft.imageView.image.size.height))];
        btnLeft.contentMode = UIViewContentModeCenter;
        [btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -kMySize(btnLeft.imageView.image.size.width) * 2 - 3, 0, 0)];
    }
    [btnLeft addTarget:self action:@selector(leftBarButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)leftBarButtonItemEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_tableView) [_tableView setEditing:NO animated:YES];
    [self.view hideAllHud];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self removeBaseKeyboardMointer];
}

- (void)iOS11ContentInsetAdjustment {
    if (_tableView) {
        if (@available(iOS 11.0, *)) {
            if (_isInsetAdjustment) {
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            } else {
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
    }
}

#pragma mark - Setter & Getter
- (BOOL)isVisible {
    return (self.isViewLoaded && self.view.window);
}

- (void)setIsInsetAdjustment:(BOOL)isInsetAdjustment {
    _isInsetAdjustment = isInsetAdjustment;
    self.automaticallyAdjustsScrollViewInsets = isInsetAdjustment;
    self.tabBarController.automaticallyAdjustsScrollViewInsets = isInsetAdjustment;
    [self iOS11ContentInsetAdjustment];
}

- (JFNetworkRequest *)request {
    if (_request == nil) {
        _request = [[JFNetworkRequest alloc] init];
    }
    return _request;
}

- (JFNetworkRequest *)upload {
    if (_upload == nil) {
        _upload = [[JFNetworkRequest alloc] init];
    }
    return _upload;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, ZSWid, ZSHei);
        _tableView = [[UITableView alloc] initWithFrame:frame style:self.tableViewStyple];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 100.0;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.directionalLockEnabled = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = YES;
        [self iOS11ContentInsetAdjustment];
    }
    return _tableView;
}

- (ZCAdaptBar *)bottomAdaptBar {
    if (!_bottomAdaptBar) {
        CGRect rect = CGRectMake(0, ZSHei - 49.0, 0, 49.0);
        _bottomAdaptBar = [[ZCAdaptBar alloc] initWithFrame:rect position:ZCEnumAdaptBarPositionBottom];
        _bottomAdaptBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bottomAdaptBar];
    }
    return _bottomAdaptBar;
}

- (ZCAdaptBar *)topAdaptBar {
    if (!_topAdaptBar) {
        CGRect rect = CGRectMake(0, 0, 0, 44.0);
        _topAdaptBar = [[ZCAdaptBar alloc] initWithFrame:rect position:ZCEnumAdaptBarPositionTop];
        _topAdaptBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_topAdaptBar];
    }
    return _topAdaptBar;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

#pragma mark - MJRefresh
- (void)stopMJRefresh:(UITableView *)tableView {
    if (tableView == nil) return;
    if (tableView.mj_header && tableView.mj_header.isRefreshing) {
        [tableView.mj_header endRefreshing];
    }
    if (tableView.mj_footer && tableView.mj_footer.isRefreshing) {
        [tableView.mj_footer endRefreshing];
    }
}

- (void)saveMJRefresh:(UITableView *)tableView parameter:(JFNetworkParameter *)parameter last:(BOOL)last {
    if (parameter) parameter.var_loadlast = last;
    if (last) {
        if (tableView && tableView.mj_footer) [tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        if (tableView && tableView.mj_footer) [tableView.mj_footer resetNoMoreData];
    }
}

- (void)resetMJRefresh:(UITableView *)tableView parameter:(JFNetworkParameter *)parameter {
    if (tableView == nil) return;
    if (tableView.mj_header && tableView.mj_header.isRefreshing) {
        [tableView.mj_header endRefreshing];
    }
    if (tableView.mj_footer) {
        if (tableView.mj_footer.isRefreshing) [tableView.mj_footer endRefreshing];
        if (parameter.var_loadlast) [tableView.mj_footer resetNoMoreData];
        else [tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)reloadMJRefresh:(UITableView *)tableView parameter:(JFNetworkParameter *)parameter {
    if (tableView == nil) return;
    if (tableView.mj_header && tableView.mj_header.isRefreshing) {
        [tableView.mj_header endRefreshing];
    }
    if (tableView.mj_footer) {
        if (tableView.mj_footer.isRefreshing) [tableView.mj_footer endRefreshing];
        if (parameter.var_loadlast) [tableView.mj_footer endRefreshingWithNoMoreData];
        else [tableView.mj_footer resetNoMoreData];
    }
}

#pragma mark - Content Tip
- (UILabel *)tipBaseLabel {
    if (!_tipBaseLabel) {
        _tipBaseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipBaseLabel.numberOfLines = 0;
        _tipBaseLabel.textColor = ZCSPColor;
        _tipBaseLabel.font = ZCFont(14);
        _tipBaseLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_tipBaseLabel];
    }
    return _tipBaseLabel;
}

- (UIImageView *)tipBaseImageView {
    if (!_tipBaseImageView) {
        _tipBaseImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_tipBaseImageView];
    }
    return _tipBaseImageView;
}

- (void)showContentTip:(NSString *)tip image:(UIImage *)image tap:(void (^)(void))tap {
    self.tipBaseLabel.text = tip;
    self.tipBaseImageView.image = image;
    [self displayAndLayoutTip];
    [self displayTipTapGes:tap];
}

- (void)displayTipTapGes:(void(^)(void))tap {
    if (tap) {
        _tipTapGesBlock = tap;
        UITapGestureRecognizer *tipGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipTapGesClick:)];
        [self.view addGestureRecognizer:tipGes];
    }
}

- (void)tipTapGesClick:(UIGestureRecognizer *)ges {
    self.tipBaseLabel.hidden = YES;
    self.tipBaseImageView.hidden = YES;
    [self.view removeGestureRecognizer:ges];
    if (_tipTapGesBlock) {
        _tipTapGesBlock();
        _tipTapGesBlock = nil;
    }
}

- (void)displayAndLayoutTip {
    if (self.tipBaseImageView.image) {
        self.tipBaseImageView.hidden = NO;
        self.tipBaseImageView.size = self.tipBaseImageView.image.size;
        [self.view bringSubviewToFront:self.tipBaseImageView];
    } else {
        self.tipBaseImageView.hidden = YES;
    }
    if (self.tipBaseLabel.text.length) {
        self.tipBaseLabel.hidden = NO;
        self.tipBaseLabel.size = [self.tipBaseLabel sizeThatFits:CGSizeMake(self.view.width - 80.0, 100.0)];
        [self.view bringSubviewToFront:self.tipBaseLabel];
    } else {
        self.tipBaseLabel.hidden = YES;
    }
    self.tipBaseImageView.centerX = self.view.width / 2.0;
    self.tipBaseLabel.centerX = self.tipBaseImageView.centerX;
    if (self.tipBaseImageView.image && self.tipBaseLabel.text.length) {
        CGFloat height = self.tipBaseLabel.height + self.tipBaseImageView.height + 20.0;
        self.tipBaseImageView.top = self.view.height / 2.0 - height / 2.0;
        self.tipBaseLabel.top = self.tipBaseImageView.bottom + 20.0;
    } else if (self.tipBaseImageView.image) {
        self.tipBaseImageView.centerY = self.view.height / 2.0;
    } else {
        self.tipBaseLabel.centerY = self.view.height / 2.0;
    }
}

#pragma mark - Keyboard Tap
- (void)addBaseKeyboardMointer {
    if (!_mointerBaseKeyboardTapGes) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKBBaseShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKBBaseHide:) name:UIKeyboardDidHideNotification object:nil];
        _mointerBaseKeyboardTapGes = YES;
    }
}

- (void)removeBaseKeyboardMointer {
    if (_mointerBaseKeyboardTapGes) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        _mointerBaseKeyboardTapGes = NO;
    }
}

- (void)setIsTableViewKeyboardControl:(BOOL)isTableViewKeyboardControl {
    _isTableViewKeyboardControl = isTableViewKeyboardControl;
    if (_isTableViewKeyboardControl) {
        if (!self.keyboardBaseTapGes.view) {
            [self.tableView addGestureRecognizer:self.keyboardBaseTapGes];
            [self addBaseKeyboardMointer];
        }
    } else {
        if (self.keyboardBaseTapGes.view) {
            [self.tableView removeGestureRecognizer:self.keyboardBaseTapGes];
            [self removeBaseKeyboardMointer];
        }
    }
}

- (JFGestureAgent *)agentBaseTransfer {  // 防止代理重叠，进而处理了别的手势
    if (!_agentBaseTransfer) {
        _agentBaseTransfer = [[JFGestureAgent alloc] initWithDelegate:self];
    }
    return _agentBaseTransfer;
}

- (UITapGestureRecognizer *)keyboardBaseTapGes {
    if (!_keyboardBaseTapGes) {
        _keyboardBaseTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTriggerKeyboardBaseTapGes:)];
        _keyboardBaseTapGes.delegate = self.agentBaseTransfer;
    }
    return _keyboardBaseTapGes;
}

- (void)onKBBaseShow:(id)sender {
    self.showBaseKeyboard = YES;
}

- (void)onKBBaseHide:(id)sender {
    self.showBaseKeyboard = NO;
}

- (void)onTriggerKeyboardBaseTapGes:(UIGestureRecognizer *)keyboardBaseTapGes {
    [self.tableView endEditing:YES];
    CGPoint point = [keyboardBaseTapGes locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (BOOL)agentGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == _keyboardBaseTapGes) {
        if (!_isTableViewKeyboardControl) {
            return NO;
        }
        if (!self.showBaseKeyboard && [touch.view isDescendantOfView:self.tableView]) {
            return NO;
        }
    }
    return YES;
}

@end
