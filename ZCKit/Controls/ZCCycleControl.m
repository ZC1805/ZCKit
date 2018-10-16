//
//  ZCCycleControl.m
//  ZCKit
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCCycleControl.h"
#import "ZCKitBridge.h"
#import "UIView+ZC.h"

static CGSize const kDefaultDotSize = {6.0, 6.0};
static NSString *ident = @"cycleControlCell";

#pragma mark - ZCCycleAnimatedDot
@interface ZCCycleAnimatedDot : UIView

@property (nonatomic, strong) UIColor *dotColor;

@end

@implementation ZCCycleAnimatedDot

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    self.layer.borderColor = dotColor.CGColor;
}

- (void)initialization {
    _dotColor = [UIColor whiteColor];
    self.backgroundColor  = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)changeActivityState:(BOOL)active {
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}

- (void)animateToActiveState {
    self.backgroundColor = _dotColor;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:nil];
}

- (void)animateToDeactiveState {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end


#pragma mark - ZCCyclePageControl
@class ZCCyclePageControl;

@protocol ZCCyclePageControlDelegate <NSObject>

- (void)cyclePageControl:(ZCCyclePageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end

@interface ZCCyclePageControl : UIControl

@property (nonatomic, copy) NSString *dotViewClass;

@property (nonatomic, strong) UIImage *dotImage;

@property (nonatomic, strong) UIImage *currentDotImage;

@property (nonatomic, assign) CGSize dotSize;

@property (nonatomic, strong) UIColor *dotColor;

@property (nonatomic, assign) NSInteger spacingBetweenDots;

@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *dots;

@property (nonatomic, weak) id<ZCCyclePageControlDelegate> delegate;

@end

@implementation ZCCyclePageControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.dotViewClass = NSStringFromClass([ZCCycleAnimatedDot class]);
    self.spacingBetweenDots = 7.0;
    self.numberOfPages = 0;
    self.currentPage = 0;
    self.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        NSInteger index = [self.dots indexOfObject:touch.view];
        if (index != NSNotFound && self.delegate && [self.delegate respondsToSelector:@selector(cyclePageControl:didSelectPageAtIndex:)]) {
            [self.delegate cyclePageControl:self didSelectPageAtIndex:index];
        }
    }
}

- (void)sizeToFit {
    [self updateFrame:YES];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    return CGSizeMake((self.dotSize.width + self.spacingBetweenDots) * pageCount - self.spacingBetweenDots, self.dotSize.height);
}

- (void)updateDots {
    if (self.numberOfPages == 0) return;
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        UIView *dot = nil;
        if (i < self.dots.count) {
            dot = [self.dots objectAtIndex:i];
        } else {
            dot = [self generateDotView];
        }
        [self updateDotFrame:dot atIndex:i];
    }
    [self changeActivity:YES atIndex:self.currentPage];
    self.hidden = self.dots.count == 1;
}

- (void)updateFrame:(BOOL)overrideExistingFrame {
    CGPoint center = self.center;
    CGSize requiredSize = [self sizeForNumberOfPages:self.numberOfPages];
    if (overrideExistingFrame || ((self.width < requiredSize.width || self.height < requiredSize.height) && !overrideExistingFrame)) {
        self.frame = CGRectMake(self.left, self.top, requiredSize.width, requiredSize.height);
        self.center = center;
    }
    [self resetDotViews];
}

- (void)updateDotFrame:(UIView *)dot atIndex:(NSInteger)index {
    CGFloat x = (self.dotSize.width + self.spacingBetweenDots) * index + ((self.width - [self sizeForNumberOfPages:self.numberOfPages].width) / 2.0);
    CGFloat y = (self.height - self.dotSize.height) / 2.0;
    dot.frame = CGRectMake(x, y, self.dotSize.width, self.dotSize.height);
}

- (UIView *)generateDotView {
    UIView *dotView = nil;
    if (self.dotViewClass) {
        dotView = [[NSClassFromString(self.dotViewClass) alloc] initWithFrame:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height)];
        if ([dotView isKindOfClass:[ZCCycleAnimatedDot class]] && self.dotColor) {
            ((ZCCycleAnimatedDot *)dotView).dotColor = self.dotColor;
        }
    } else {
        dotView = [[UIImageView alloc] initWithImage:self.dotImage];
        dotView.frame = CGRectMake(0, 0, self.dotSize.width, self.dotSize.height);
    }
    if (dotView) {
        [self addSubview:dotView];
        [self.dots addObject:dotView];
    }
    dotView.userInteractionEnabled = YES;
    return dotView;
}

- (void)changeActivity:(BOOL)active atIndex:(NSInteger)index {
    if (self.dotViewClass) {
        ZCCycleAnimatedDot *abstractDotView = (ZCCycleAnimatedDot *)[self.dots objectAtIndex:index];
        [abstractDotView changeActivityState:active];
    } else if (self.dotImage && self.currentDotImage) {
        UIImageView *dotView = (UIImageView *)[self.dots objectAtIndex:index];
        dotView.image = active ? self.currentDotImage : self.dotImage;
    }
}

- (void)resetDotViews {
    for (UIView *dotView in self.dots) {
        [dotView removeFromSuperview];
    }
    [self.dots removeAllObjects];
    [self updateDots];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self resetDotViews];
}

- (void)setSpacingBetweenDots:(NSInteger)spacingBetweenDots {
    _spacingBetweenDots = spacingBetweenDots;
    [self resetDotViews];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (self.numberOfPages == 0 || currentPage == _currentPage) {
        _currentPage = currentPage;
        return;
    }
    [self changeActivity:NO atIndex:_currentPage];
    _currentPage = currentPage;
    [self changeActivity:YES atIndex:_currentPage];
}

- (void)setDotImage:(UIImage *)dotImage {
    _dotImage = dotImage;
    [self resetDotViews];
    self.dotViewClass = nil;
}

- (void)setCurrentDotImage:(UIImage *)currentDotimage {
    _currentDotImage = currentDotimage;
    [self resetDotViews];
    self.dotViewClass = nil;
}

- (void)setDotViewClass:(NSString *)dotViewClass {
    _dotViewClass = dotViewClass;
    self.dotSize = CGSizeZero;
    [self resetDotViews];
}

- (NSMutableArray *)dots {
    if (!_dots) {
        _dots = [[NSMutableArray alloc] init];
    }
    return _dots;
}

- (CGSize)dotSize {
    if (self.dotImage && CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        _dotSize = self.dotImage.size;
    } else if (self.dotViewClass && CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        _dotSize = kDefaultDotSize;
    }
    return _dotSize;
}

@end


#pragma mark - ZCCycleCell
@interface ZCCycleCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, assign) BOOL hasConfigured;

@property (nonatomic, assign) BOOL onlyDisplayText;

@end

@implementation ZCCycleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    return self;
}

- (void)setupImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.height = 30.0;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
        _titleLabel.frame = CGRectMake(0, self.height - _titleLabel.height, self.width, _titleLabel.height);
    }
}

@end


#pragma mark - ZCCycleControl
@interface ZCCycleControl () <UICollectionViewDataSource, UICollectionViewDelegate, ZCCyclePageControlDelegate>

@property (nonatomic, weak) UICollectionView *mainView;

@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, weak) UIControl *pageControl;

@property (nonatomic, strong) NSArray *imagePathsGroup;

@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ZCCycleControl

#pragma mark - initial
+ (instancetype)cycleControlFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLsGroup {
    ZCCycleControl *cycleView = [[self alloc] initWithFrame:frame];
    cycleView.imageURLStringsGroup = [NSMutableArray arrayWithArray:imageURLsGroup];
    return cycleView;
}

+ (instancetype)cycleControlFrame:(CGRect)frame delegate:(id<ZCCycleControlDelegate>)delegate holderImage:(UIImage *)holderImage {
    ZCCycleControl *cycleView = [[self alloc] initWithFrame:frame];
    cycleView.delegate = delegate;
    cycleView.placeholderImage = holderImage;
    return cycleView;
}

+ (instancetype)cycleControlFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup {
    ZCCycleControl *cycleView = [[self alloc] initWithFrame:frame];
    cycleView.infiniteLoop = infiniteLoop;
    cycleView.localizationImageNamesGroup = [NSMutableArray arrayWithArray:imageNamesGroup];
    return cycleView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)initialization {
    _autoScroll = YES;
    _infiniteLoop = YES;
    _onlyDisplayText = NO;
    _showPageControl = YES;
    _autoScrollTimeInterval = 4.0;
    _imageViewContentMode = UIViewContentModeScaleToFill;
    _pageControlDotSize = kDefaultDotSize;
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _pageControlSpacing = 7.0;
    _pageControlAliment = ZCEnumCycleAlimentCenter;
    _pageControlStyle = ZCEnumCyclePageStyleAnimated;
    _pageDotSelectColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
}

- (void)setupMainView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.directionalLockEnabled = YES;
    [mainView registerClass:[ZCCycleCell class] forCellWithReuseIdentifier:ident];
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self addSubview:mainView];
    _mainView = mainView;
}

#pragma mark - property
- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (!_backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:self.mainView];
        _backgroundImageView = bgImageView;
    }
    _backgroundImageView.image = placeholderImage;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize {
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[ZCCyclePageControl class]]) {
        ZCCyclePageControl *pageContol = (ZCCyclePageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setPageControlSpacing:(CGFloat)pageControlSpacing {
    _pageControlSpacing = pageControlSpacing;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[ZCCyclePageControl class]]) {
        ZCCyclePageControl *pageContol = (ZCCyclePageControl *)_pageControl;
        pageContol.spacingBetweenDots = pageControlSpacing;
    }
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setPageDotSelectColor:(UIColor *)pageDotSelectColor {
    _pageDotSelectColor = pageDotSelectColor;
    if ([self.pageControl isKindOfClass:[ZCCyclePageControl class]]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        pageControl.dotColor = pageDotSelectColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = pageDotSelectColor;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor {
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage {
    _currentPageDotImage = currentPageDotImage;
    if (self.pageControlStyle != ZCEnumCyclePageStyleAnimated) {
        self.pageControlStyle = ZCEnumCyclePageStyleAnimated;
    }
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage {
    _pageDotImage = pageDotImage;
    if (self.pageControlStyle != ZCEnumCyclePageStyleAnimated) {
        self.pageControlStyle = ZCEnumCyclePageStyleAnimated;
    }
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot {
    if (!image || !self.pageControl) return;
    if ([self.pageControl isKindOfClass:[ZCCyclePageControl class]]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage = image;
        }
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (_autoScroll) [self setupTimer];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}

- (void)setPageControlStyle:(ZCEnumCyclePageStyle)pageControlStyle {
    _pageControlStyle = pageControlStyle;
    [self setupPageControl];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup {
    [self invalidateTimer];
    _imagePathsGroup = imagePathsGroup;
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : self.imagePathsGroup.count;
    if (imagePathsGroup.count != 1) {
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainView.scrollEnabled = NO;
    }
    [self setupPageControl];
    [self.mainView reloadData];
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup {
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.imagePathsGroup = [localizationImageNamesGroup copy];
}

- (void)setTitlesGroup:(NSArray *)titlesGroup {
    _titlesGroup = titlesGroup;
    if (self.onlyDisplayText) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < _titlesGroup.count; i++) {
            [temp addObject:@""];
        }
        self.backgroundColor = [UIColor clearColor];
        self.imageURLStringsGroup = [temp copy];
    }
}

#pragma mark - actions
- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)setupPageControl {
    if (_pageControl) [_pageControl removeFromSuperview];  //重新加载数据时调整
    if (self.imagePathsGroup.count == 0 || self.onlyDisplayText) return;
    if (self.imagePathsGroup.count == 1) return;
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    switch (self.pageControlStyle) {
        case ZCEnumCyclePageStyleAnimated: {
            ZCCyclePageControl *pageControl = [[ZCCyclePageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.dotColor = self.pageDotSelectColor;
            pageControl.userInteractionEnabled = YES;
            pageControl.currentPage = indexOnPageControl;
            pageControl.delegate = self;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        } break;
        case ZCEnumCyclePageStyleClassic:{
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.currentPageIndicatorTintColor = self.pageDotSelectColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        } break;
        default: break;
    }
    if (self.currentPageDotImage) {  //重设pagecontroldot图片
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
}

- (void)automaticScroll {
    if (_totalItemsCount == 0) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= _totalItemsCount) {
        if (!self.infiniteLoop) return;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(_totalItemsCount * 0.5) inSection:0] atScrollPosition:0 animated:NO];
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:0 animated:YES];
}

- (int)currentIndex {
    if (_mainView.width == 0 || _mainView.height == 0) {
        return 0;
    }
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.imagePathsGroup.count;
}

#pragma mark - circles
- (void)layoutSubviews {
    [super layoutSubviews];
    _flowLayout.itemSize = self.frame.size;
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        } else {
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:0 animated:NO];
    }
    
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[ZCCyclePageControl class]]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kDefaultDotSize, self.pageControlDotSize))) {
            pageControl.dotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count];
    } else {
        size = CGSizeMake(self.imagePathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    }
    CGFloat x = (self.width - size.width) * 0.5;
    if (self.pageControlAliment == ZCEnumCycleAlimentRight) {
        x = self.mainView.width - size.width - 10.0;
    }
    CGFloat y = self.mainView.height - size.height - 10.0;
    
    if ([self.pageControl isKindOfClass:[ZCCyclePageControl class]]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {  //解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
    if (!newSuperview) [self invalidateTimer];
}

- (void)dealloc {  //解决当timer释放后，回调scrollViewDidScroll时访问野指针导致崩溃
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
    [self invalidateTimer];
}

#pragma mark - public actions
- (void)adjustWhenControllerViewWillAppera {
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:0 animated:NO];
    }
}

#pragma mark - ZCCyclePageControlDelegate
- (void)cyclePageControl:(ZCCyclePageControl *)pageControl didSelectPageAtIndex:(NSInteger)index {
    [self scrollToIndex:(int)index];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    if (!self.onlyDisplayText && [imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [ZCKitBridge.realize imageViewWebCache:cell.imageView url:[NSURL URLWithString:imagePath] holder:self.placeholderImage];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) [UIImage imageWithContentsOfFile:imagePath];
            cell.imageView.image = image;
        }
    } else if (!self.onlyDisplayText && [imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    if (_titlesGroup.count && itemIndex < _titlesGroup.count) {
        cell.title = _titlesGroup[itemIndex];
    }
    if (!cell.hasConfigured) {
        if (self.titleLableSet) self.titleLableSet(cell.titleLabel);
        cell.hasConfigured = YES;
        cell.imageView.contentMode = self.imageViewContentMode;
        cell.clipsToBounds = YES;
        cell.onlyDisplayText = self.onlyDisplayText;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(cycleControl:didSelectAtIndex:)]) {
        [self.delegate cycleControl:self didSelectAtIndex:indexOnPageControl];
    } else if (self.clickCallback) {
        self.clickCallback(indexOnPageControl);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) return;  //解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if ([self.pageControl isKindOfClass:[ZCCyclePageControl class]]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) [self setupTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) return;  //解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if ([self.delegate respondsToSelector:@selector(cycleControl:didScrollToIndex:)]) {
        [self.delegate cycleControl:self didScrollToIndex:indexOnPageControl];
    } else if (self.scrollCallback) {
        self.scrollCallback(indexOnPageControl);
    }
}

@end

