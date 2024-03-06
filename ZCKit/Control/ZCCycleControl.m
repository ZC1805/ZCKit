//
//  ZCCycleControl.m
//  ZCKit
//
//  Created by admin on 2018/10/16.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCCycleControl.h"
#import "ZCKitBridge.h"
#import "ZCImageView.h"
#import "ZCLabel.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

static const CGSize kDefaultDotSize = {6.0, 6.0};
static NSString * const ident = @"cycleControlCell";

#pragma mark - ~ ZCCycleAnimatedDot ~
@interface ZCCycleAnimatedDot : UIView

@property (nonatomic, strong) UIColor *dotColor;

@end

@implementation ZCCycleAnimatedDot

- (instancetype)initWithFrame:(CGRect)frame {
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
    _dotColor = kZCWhite;
    self.backgroundColor = kZCClear;
    self.layer.cornerRadius = self.zc_width / 2.0;
    self.layer.borderColor = kZCWhite.CGColor;
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
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:nil];
}

- (void)animateToDeactiveState {
    self.backgroundColor = kZCClear;
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end


#pragma mark - ~ ZCCyclePageControl ~
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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.dotViewClass = NSStringFromClass(ZCCycleAnimatedDot.class);
    self.spacingBetweenDots = 7.0;
    self.numberOfPages = 0;
    self.currentPage = 0;
    self.backgroundColor = kZCClear;
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
    if (overrideExistingFrame || ((self.zc_width < requiredSize.width || self.zc_height < requiredSize.height) && !overrideExistingFrame)) {
        self.frame = CGRectMake(self.zc_left, self.zc_top, requiredSize.width, requiredSize.height);
        self.center = center;
    }
    [self resetDotViews];
}

- (void)updateDotFrame:(UIView *)dot atIndex:(NSInteger)index {
    CGFloat x = (self.dotSize.width + self.spacingBetweenDots) * index + ((self.zc_width - [self sizeForNumberOfPages:self.numberOfPages].width) / 2.0);
    CGFloat y = (self.zc_height - self.dotSize.height) / 2.0;
    dot.frame = CGRectMake(x, y, self.dotSize.width, self.dotSize.height);
}

- (UIView *)generateDotView {
    UIView *dotView = nil;
    if (self.dotViewClass) {
        dotView = [[NSClassFromString(self.dotViewClass) alloc] initWithFrame:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height)];
        if ([dotView isKindOfClass:ZCCycleAnimatedDot.class] && self.dotColor) {
            ((ZCCycleAnimatedDot *)dotView).dotColor = self.dotColor;
        }
    } else {
        dotView = [[ZCImageView alloc] initWithFrame:CGRectZero image:self.dotImage];
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
        ZCImageView *dotView = (ZCImageView *)[self.dots objectAtIndex:index];
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


#pragma mark - ~ ZCCycleCell ~
@interface ZCCycleCell ()

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isHasConfigured;

@property (nonatomic, assign) BOOL isOnlyDisplayText;

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
    ZCImageView *imageView = [[ZCImageView alloc] initWithFrame:CGRectZero image:nil];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel {
    ZCLabel *titleLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
    _titleLabel = titleLabel;
    _titleLabel.textColor = kZCWhite;
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    _titleLabel.backgroundColor = kZCA(kZCBlack, 0.4);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.zc_height = 30.0;
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
    if (self.isOnlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
        _titleLabel.frame = CGRectMake(0, self.zc_height - _titleLabel.zc_height, self.zc_width, _titleLabel.zc_height);
    }
}

@end


#pragma mark - ~ ZCCycleFlowLayout ~
@interface ZCCycleHorizontalFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat itemHorSpace; //横向滚动时，每张轮播图的间距

@property (nonatomic, assign) CGFloat itemMinScale; //前后2张图的缩小比例(0.1 ~ 1.0)

@property (nonatomic, assign) CGFloat itemHorInit; //前后2张图的缩小比例(0.1 ~ 1.0)

@end

@implementation ZCCycleHorizontalFlowLayout

- (instancetype)initWithItemHorSpace:(CGFloat)itemHorSpace itemHorInit:(CGFloat)itemHorInit {
    if (self = [super init]) {
        self.itemMinScale = 0.95;
        self.itemHorSpace = itemHorSpace;
        self.itemHorInit = itemHorInit;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat onePage = self.collectionView.zc_width - 2.0 * self.itemHorInit - self.itemHorSpace;
    self.sectionInset = UIEdgeInsetsMake(0, self.itemHorSpace / 2.0, 0, self.itemHorSpace / 2.0);
    self.itemSize = CGSizeMake(onePage - self.itemHorSpace, self.collectionView.zc_height);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = self.itemHorSpace;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *>*atts = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.zc_width * 0.5;
    for (UICollectionViewLayoutAttributes *attri in atts) {
        CGFloat delta = ABS(attri.center.x - centerX);
        CGFloat scale = 1.0 - delta / self.collectionView.zc_width * (1.0 - self.itemMinScale);
        attri.transform = CGAffineTransformMakeScale(1.0, scale);
    }
    return atts;
}

- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    CGFloat baseOffset = self.itemHorInit + self.itemHorSpace / 2.0;
    return CGSizeMake(size.width + baseOffset, size.height);
}

@end


#pragma mark - ~ ZCCycleControl ~
@interface ZCCycleControl () <UICollectionViewDataSource, UICollectionViewDelegate, ZCCyclePageControlDelegate>

@property (nonatomic, weak) UICollectionView *mainView;

@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, weak) UIControl *pageControl;

@property (nonatomic, assign) BOOL isInitLoop;

@property (nonatomic, assign) BOOL isInfiniteLoop;

@property (nonatomic, assign) CGFloat itemHorSpace;

@property (nonatomic, assign) CGFloat itemHorInit;

@property (nonatomic, assign) int dragBeginIndex;

@property (nonatomic, strong) NSArray *imagePathsGroup;

@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, strong) ZCImageView *backgroundImageView;

@end

@implementation ZCCycleControl

#pragma mark - Initial
- (instancetype)initWithFrame:(CGRect)frame shouldLoop:(BOOL)loop imageUrlGroup:(NSArray *)imageUrlGroup {
    if (self = [super initWithFrame:frame]) {
        [self initialization:0];
        [self setupMainView];
        self.isInitLoop = loop;
        if (imageUrlGroup) {
            self.imageURLStringsGroup = [NSMutableArray arrayWithArray:imageUrlGroup];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame shouldLoop:(BOOL)loop delegate:(id<ZCCycleControlDelegate>)delegate holder:(nullable UIImage *)holder {
    if (self = [super initWithFrame:frame]) {
        [self initialization:0];
        [self setupMainView];
        self.isInitLoop = loop;
        self.delegate = delegate;
        if (holder) self.placeholderImage = holder;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame shouldLoop:(BOOL)loop imageGroup:(NSArray *)imageGroup itemHorSpace:(CGFloat)itemHorSpace {
    if (self = [super initWithFrame:frame]) {
        [self initialization:itemHorSpace];
        [self setupMainView];
        self.isInitLoop = loop;
        if (imageGroup) {
            self.localizationImageGroup = [NSMutableArray arrayWithArray:imageGroup];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization:0];
        [self setupMainView];
    }
    return self;
}

- (void)initialization:(CGFloat)space {
    _itemHorSpace = space;
    _itemHorInit = space;
    _dragBeginIndex = -1;
    _isAutoScroll = YES;
    _isInfiniteLoop = NO;
    _isOnlyDisplayText = NO;
    _isShowPageControl = YES;
    _autoScrollTimeInterval = 4.0;
    _imageViewContentMode = UIViewContentModeScaleToFill;
    _pageControlDotSize = kDefaultDotSize;
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _pageControlSpacing = 7.0;
    _pageControlAliment = ZCEnumCycleAlimentCenter;
    _pageControlStyle = ZCEnumCyclePageStyleAnimated;
    _pageDotSelectColor = kZCWhite;
    _pageDotColor = kZCBlackA6;
}

- (void)setupMainView {
    self.backgroundColor = kZCWhite;
    UICollectionViewFlowLayout *flowLayout = nil;
    if (_itemHorSpace <= 0) {
        flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.zc_size;
        flowLayout.minimumLineSpacing = 0;
    } else {
        flowLayout = [[ZCCycleHorizontalFlowLayout alloc] initWithItemHorSpace:_itemHorSpace itemHorInit:_itemHorInit];
    }
    _flowLayout = flowLayout;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    if (@available(iOS 11.0, *)) { mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; }
    mainView.backgroundColor = kZCClear;
    mainView.pagingEnabled = _itemHorSpace <= 0;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.directionalLockEnabled = YES;
    [mainView registerClass:ZCCycleCell.class forCellWithReuseIdentifier:ident];
    mainView.clipsToBounds = YES;
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    mainView.bounces = YES;
    [self addSubview:mainView];
    _mainView = mainView;
}

#pragma mark - Property
- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (!_backgroundImageView) {
        ZCImageView *bgImageView = [[ZCImageView alloc] initWithFrame:CGRectZero];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:_mainView];
        _backgroundImageView = bgImageView;
    }
    _backgroundImageView.image = placeholderImage;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize {
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:ZCCyclePageControl.class]) {
        ZCCyclePageControl *pageContol = (ZCCyclePageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setPageControlSpacing:(CGFloat)pageControlSpacing {
    _pageControlSpacing = pageControlSpacing;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:ZCCyclePageControl.class]) {
        ZCCyclePageControl *pageContol = (ZCCyclePageControl *)_pageControl;
        pageContol.spacingBetweenDots = pageControlSpacing;
    }
}

- (void)setIsShowPageControl:(BOOL)isShowPageControl {
    _isShowPageControl = isShowPageControl;
    _pageControl.hidden = !isShowPageControl;
}

- (void)setPageDotSelectColor:(UIColor *)pageDotSelectColor {
    _pageDotSelectColor = pageDotSelectColor;
    if ([self.pageControl isKindOfClass:ZCCyclePageControl.class]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        pageControl.dotColor = pageDotSelectColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = pageDotSelectColor;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor {
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:UIPageControl.class]) {
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
    if ([self.pageControl isKindOfClass:ZCCyclePageControl.class]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage = image;
        }
    }
}

- (void)setIsInfiniteLoop:(BOOL)isInfiniteLoop {
    _isInfiniteLoop = isInfiniteLoop;
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = _imagePathsGroup;
    }
}

- (void)setIsAutoScroll:(BOOL)isAutoScroll {
    _isAutoScroll = isAutoScroll;
    [self invalidateTimer];
    if (_isAutoScroll) { [self setupTimer]; }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    if (_itemHorSpace <= 0) {
        _flowLayout.scrollDirection = scrollDirection;
    }
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setIsAutoScroll:self.isAutoScroll];
}

- (void)setPageControlStyle:(ZCEnumCyclePageStyle)pageControlStyle {
    _pageControlStyle = pageControlStyle;
    [self setupPageControl];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup {
    [self invalidateTimer];
    _dragBeginIndex = -1;
    _imagePathsGroup = imagePathsGroup;
    _isInfiniteLoop = self.isInitLoop && imagePathsGroup.count > 1;
    _totalItemsCount = self.isInfiniteLoop ? imagePathsGroup.count * 100 : imagePathsGroup.count;
    if (imagePathsGroup.count > 1) {
        _mainView.scrollEnabled = YES;
        [self setIsAutoScroll:self.isAutoScroll];
    } else {
        _mainView.scrollEnabled = NO;
    }
    [self setupPageControl];
    [_mainView reloadData];
    [_mainView setNeedsLayout];
    [_mainView layoutIfNeeded];
    [self layoutSubviews];
    self.backgroundImageView.hidden = imagePathsGroup.count;
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    NSMutableArray *temp = [NSMutableArray array];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:NSString.class]) {
            urlString = obj;
        } else if ([obj isKindOfClass:NSURL.class]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setLocalizationImageGroup:(NSArray *)localizationImageGroup {
    _localizationImageGroup = localizationImageGroup;
    if (localizationImageGroup) {
        self.imagePathsGroup = [localizationImageGroup copy];
    }
}

- (void)setTitlesGroup:(NSArray *)titlesGroup {
    _titlesGroup = titlesGroup;
    if (self.isOnlyDisplayText) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < _titlesGroup.count; i++) {
            [temp addObject:@""];
        }
        self.imageURLStringsGroup = [temp copy];
    }
}

#pragma mark - Actions
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
    if (_pageControl) { [_pageControl removeFromSuperview]; } //重新加载数据时调整
    if (self.imagePathsGroup.count == 0 || self.isOnlyDisplayText) return;
    if (self.imagePathsGroup.count == 1) return;
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    switch (self.pageControlStyle) {
        case ZCEnumCyclePageStyleAnimated: {
            ZCCyclePageControl *pageControl = [[ZCCyclePageControl alloc] initWithFrame:CGRectZero];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.dotColor = self.pageDotSelectColor;
            pageControl.userInteractionEnabled = YES;
            pageControl.currentPage = indexOnPageControl;
            pageControl.delegate = self;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        } break;
        case ZCEnumCyclePageStyleClassic:{
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
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
    if (self.currentPageDotImage) { //重设pagecontroldot图片
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
    [self scrollToIndex:targetIndex isAnimate:YES];
}

- (void)scrollToIndex:(int)targetIndex isAnimate:(BOOL)isAnimate {
    if (self.isInfiniteLoop) {
        if (_totalItemsCount <= 0) {
            isAnimate = NO; targetIndex = 0;
        }
        else if (targetIndex >= _totalItemsCount * 0.8) {
            isAnimate = NO; targetIndex = _totalItemsCount * 0.5;
        }
        else if (targetIndex < _totalItemsCount * 0.2) {
            isAnimate = NO; targetIndex = _totalItemsCount * 0.5 - 1;
        }
    } else {
        if (_itemHorSpace <= 0) {
            if (targetIndex >= _totalItemsCount) return;
        } else {
            if (targetIndex >= _totalItemsCount) {
                targetIndex = 0;
            }
        }
    }
    if (_itemHorSpace <= 0) {
        if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            CGFloat x = _flowLayout.itemSize.width * targetIndex;
            CGFloat y = _mainView.contentOffset.y;
            [_mainView setContentOffset:CGPointMake(x, y) animated:isAnimate];
        } else {
            CGFloat x = _mainView.contentOffset.x;
            CGFloat y = _flowLayout.itemSize.height * targetIndex;
            [_mainView setContentOffset:CGPointMake(x, y) animated:isAnimate];
        }
    } else {
        CGFloat baseOffset = _itemHorInit + _itemHorSpace / 2.0;
        CGFloat onePage = self.zc_width - 2.0 * _itemHorInit - _itemHorSpace;
        CGFloat x = onePage * targetIndex - baseOffset;
        CGFloat y = _mainView.contentOffset.y;
        [_mainView setContentOffset:CGPointMake(x, y) animated:isAnimate];
    }
}

- (int)currentIndex {
    if (_mainView.zc_width == 0 || _mainView.zc_height == 0) {
        return 0;
    }
    int index = 0;
    if (_itemHorSpace <= 0) {
        if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
        } else {
            index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
        }
    } else {
        CGFloat baseOffset = _itemHorInit + _itemHorSpace / 2.0;
        CGFloat onePage = self.zc_width - 2.0 * _itemHorInit - _itemHorSpace;
        index = (_mainView.contentOffset.x + baseOffset + onePage * 0.5) / onePage;
    }
    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.imagePathsGroup.count;
}

#pragma mark - Circles
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_itemHorSpace <= 0) {
        _flowLayout.itemSize = self.zc_size;
    }
    _mainView.frame = self.bounds;
    if (_itemHorSpace <= 0) {
        if (ABS(_mainView.contentOffset.x) < 1.0 && _totalItemsCount > 0) {
            int targetIndex = 0;
            if (self.isInfiniteLoop) {
                targetIndex = _totalItemsCount * 0.5;
            } else {
                targetIndex = 0;
            }
            [self scrollToIndex:targetIndex isAnimate:NO];
        }
    } else {
        CGFloat baseOffset = _itemHorInit + _itemHorSpace / 2.0;
        if ((ABS(_mainView.contentOffset.x + baseOffset) < 1.0 || ABS(_mainView.contentOffset.x) < 1.0) && _totalItemsCount > 0) {
            int targetIndex = 0;
            if (self.isInfiniteLoop) {
                targetIndex = _totalItemsCount * 0.5;
            } else {
                targetIndex = _totalItemsCount > 0 ? 1 : 0;
            }
            [self scrollToIndex:targetIndex isAnimate:NO];
        }
    }
    
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:ZCCyclePageControl.class]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kDefaultDotSize, self.pageControlDotSize))) {
            pageControl.dotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count];
    } else {
        size = CGSizeMake(self.imagePathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    }
    CGFloat x = (self.zc_width - size.width) * 0.5;
    if (self.pageControlAliment == ZCEnumCycleAlimentRight) {
        x = _mainView.zc_width - size.width - 10.0;
    }
    CGFloat y = _mainView.zc_height - size.height - 10.0;
    
    if ([self.pageControl isKindOfClass:ZCCyclePageControl.class]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_isShowPageControl;
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview { //解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
    if (!newSuperview) { [self invalidateTimer]; }
}

- (void)dealloc { //解决当timer释放后，回调scrollViewDidScroll时访问野指针导致崩溃
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
    [self invalidateTimer];
}

#pragma mark - Public actions
- (void)adjustWhenControllerViewWillAppera {
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [self scrollToIndex:(int)targetIndex isAnimate:NO];
    }
}

#pragma mark - ZCCyclePageControlDelegate
- (void)cyclePageControl:(ZCCyclePageControl *)pageControl didSelectPageAtIndex:(NSInteger)index {
    [self scrollToIndex:(int)index isAnimate:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    NSString *imagePath = self.imagePathsGroup[indexOnPageControl];
    if (!self.isOnlyDisplayText && [imagePath isKindOfClass:NSString.class]) {
        if ([imagePath hasPrefix:@"http"]) {
            [ZCKitBridge.realize imageViewWebCache:cell.imageView url:[NSURL URLWithString:imagePath] holder:self.placeholderImage];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) [UIImage imageWithContentsOfFile:imagePath];
            cell.imageView.image = image;
        }
    } else if (!self.isOnlyDisplayText && [imagePath isKindOfClass:UIImage.class]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    if (_titlesGroup.count && indexOnPageControl < _titlesGroup.count) {
        cell.title = _titlesGroup[indexOnPageControl];
    }
    if (!cell.isHasConfigured) {
        if (self.titleLableSet) self.titleLableSet(cell.titleLabel);
        cell.isHasConfigured = YES;
        cell.imageView.contentMode = self.imageViewContentMode;
        cell.clipsToBounds = YES;
        cell.isOnlyDisplayText = self.isOnlyDisplayText;
    }
    if ([self.delegate respondsToSelector:@selector(cycleControl:cell:index:)]) {
        [self.delegate cycleControl:self cell:cell index:indexOnPageControl];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(cycleControl:didSelectAtIndex:)]) {
        [self.delegate cycleControl:self didSelectAtIndex:indexOnPageControl];
    } else if (self.selectAction) {
        self.selectAction(indexOnPageControl);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) return; //解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if ([self.pageControl isKindOfClass:ZCCyclePageControl.class]) {
        ZCCyclePageControl *pageControl = (ZCCyclePageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isAutoScroll) { [self invalidateTimer]; }
    if (!scrollView.pagingEnabled) {
        _dragBeginIndex = [self currentIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isAutoScroll) [self setupTimer];
    if (!scrollView.pagingEnabled && !decelerate && _totalItemsCount > 0) {
        [self scrollToIndex:[self currentIndex] isAnimate:YES];
        _dragBeginIndex = -1;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!scrollView.pagingEnabled && velocity.x != 0 && _totalItemsCount > 0) {
        CGFloat aimOffsetX = targetContentOffset->x;
        int targetIndex = 0;
        if (_mainView.zc_width == 0 || _mainView.zc_height == 0) {
            targetIndex = 0;
        } else {
            CGFloat baseOffset = _itemHorInit + _itemHorSpace / 2.0;
            CGFloat onePage = self.zc_width - 2.0 * _itemHorInit - _itemHorSpace;
            targetIndex = (aimOffsetX + baseOffset + onePage * 0.5) / onePage;
            if (_dragBeginIndex >= 0 && targetIndex > _dragBeginIndex) { targetIndex = MIN(_dragBeginIndex + 1, targetIndex); }
            if (_dragBeginIndex >= 0 && targetIndex < _dragBeginIndex) { targetIndex = MAX(_dragBeginIndex - 1, targetIndex); }
            targetIndex = MAX(0, targetIndex);
        }
        if (self.isInfiniteLoop) {
            if (targetIndex >= _totalItemsCount * 0.8) {
                targetIndex = _totalItemsCount * 0.8;
            }
            if (targetIndex < _totalItemsCount * 0.2) {
                targetIndex = _totalItemsCount * 0.2 - 1;
            } //这个地方可以滑动到临界值
        } else {
            if (targetIndex >= _totalItemsCount) {
                targetIndex = (int)_totalItemsCount - 1;
            } //这里划到第一个间距会没
        }
        CGFloat baseOffset = _itemHorInit + _itemHorSpace / 2.0;
        CGFloat onePage = self.zc_width - 2.0 * _itemHorInit - _itemHorSpace;
        CGFloat x = onePage * targetIndex - baseOffset;
        targetContentOffset->x = x;
    }
    if (!scrollView.pagingEnabled) {
        _dragBeginIndex = -1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:_mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) return; //解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if ([self.delegate respondsToSelector:@selector(cycleControl:didScrollToIndex:)]) {
        [self.delegate cycleControl:self didScrollToIndex:indexOnPageControl];
    } else if (self.scrollAction) {
        self.scrollAction(indexOnPageControl);
    }
}

@end
