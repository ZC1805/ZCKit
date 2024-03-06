//
//  ZCPartControl.m
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCPartControl.h"
#import "ZCScrollView.h"
#import "ZCImageView.h"
#import "NSArray+ZC.h"
#import "UIColor+ZC.h"
#import "UIView+ZC.h"
#import "ZCButton.h"
#import "ZCMacro.h"

#pragma mark - ~ ZCPartSet ~
@interface ZCPartSet ()

@property (nonatomic, strong) NSArray *nca;

@property (nonatomic, strong) NSArray *sca;

@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, strong) UIColor *selectColor;

@property (nonatomic, assign) CGFloat itemSelCalwid;

@property (nonatomic, assign) CGSize itemSelMarkSize;

@end

@implementation ZCPartSet

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.normalImage = nil;
        self.selectImage = nil;
        self.normalTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.selectTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.normalColorRGB = kZCBlack30.RGBValue;
        self.selectColorRGB = kZCBlack30.RGBValue;
        self.spaceHeight = 0;
        self.imageSize = CGSizeMake(20.0, 20.0);
        self.imageTitleSpace = 0;
        self.isVerticalAlignment = YES;
        self.itemSelCalwid = 20.0;
        self.itemSelMarkSize = CGSizeMake(6.0, 2.0);
        self.isUseFixSelMarkSize = YES;
        self.calExtraAddWidth = 0;
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithTitle:@""]) {
    } return self;
}

- (void)setNormalColorRGB:(uint32_t)normalColorRGB {
    _normalColorRGB = normalColorRGB;
    _normalColor = kZCRGB(normalColorRGB);
    _nca = @[@((CGFloat)((normalColorRGB & 0xFF0000) >> 16)),
             @((CGFloat)((normalColorRGB & 0x00FF00) >> 8)),
             @((CGFloat)(normalColorRGB & 0x0000FF))];
}

- (void)setSelectColorRGB:(uint32_t)selectColorRGB {
    _selectColorRGB = selectColorRGB;
    _selectColor = kZCRGB(selectColorRGB);
    _sca = @[@((CGFloat)((selectColorRGB & 0xFF0000) >> 16)),
             @((CGFloat)((selectColorRGB & 0x00FF00) >> 8)),
             @((CGFloat)(selectColorRGB & 0x0000FF))];
}

- (void)calcelateSelectWidth {
    if (self.title) {
        NSDictionary *att = @{NSFontAttributeName : self.selectTitleFont};
        NSStringDrawingOptions ops = NSStringDrawingUsesLineFragmentOrigin;
        CGFloat wid = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, 30.0) options:ops attributes:att context:nil].size.width;
        self.itemSelCalwid = MAX(self.itemSelCalwid, ceilf(wid) + (self.calExtraAddWidth > 0.1 ? self.calExtraAddWidth : 12.0));
    }
    if (self.selectImage) {
        self.itemSelCalwid = MAX(self.itemSelCalwid, self.selectImage.size.width + (self.calExtraAddWidth > 0.1 ? self.calExtraAddWidth : 12.0));
    }
    if (self.isUseFixSelMarkSize) {
        self.itemSelMarkSize = CGSizeMake(30.0, 3.0);
    } else {
        self.itemSelMarkSize = CGSizeMake(MAX(self.itemSelCalwid - 14.0, 6.0), 2.0);
    }
}

@end


#pragma mark - ~ ZCPartControl ~
static NSString * const kvo_observe_offset = @"contentOffset";
static void *kvo_context_offset = @"segmentViewScrollView_context";
typedef void(^block)(NSInteger touchIndex);

@interface ZCPartControl ()

@property (nonatomic, assign) CGFloat markOffset;

@property (nonatomic, assign) CGFloat alphaOffset;

@property (nonatomic, strong) NSMutableArray <ZCPartSet *>*items;

@property (nonatomic, strong) NSMutableArray <ZCButton *>* allBtns;

@property (nonatomic, strong) NSMutableArray <UIView *>* allSpaces;

@property (nonatomic, strong) ZCImageView *rightAlphaView;

@property (nonatomic, strong) ZCImageView *leftAlphaView;

@property (nonatomic, weak  ) ZCScrollView *scrollView;

@property (nonatomic, strong) ZCScrollView *barView;

@property (nonatomic, strong) UIView *markView;

@property (nonatomic, assign) BOOL isObserver;

@property (nonatomic, assign) BOOL isBottomMark;

@property (nonatomic, assign) BOOL isFixItemWid;

@property (nonatomic, assign) BOOL isShieldSelect;

@property (nonatomic, assign) NSInteger selectItemIndex;

@property (nonatomic, assign) NSInteger targetScrollIndex;

@property (nonatomic, assign) NSInteger currentTapIndex;

@end

@implementation ZCPartControl

- (instancetype)initWithFrame:(CGRect)frame normalMark:(BOOL)bottomMark fixWidth:(BOOL)fixWidth {
    if (self = [super initWithFrame:frame]) {
        _isBottomMark = bottomMark;
        _isFixItemWid = fixWidth;
        [self initialSet];
        [self initialload];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self initWithFrame:frame normalMark:NO fixWidth:NO]) {
    } return self;
}

- (void)initialSet {
    _interval = 0;
    _itemWidth = 0;
    _markOffset = 30.0;
    _alphaOffset = 0;
    _isObserver = NO;
    _alphaImage = nil;
    _barColor = kZCClear;
    _markSize = CGSizeZero;
    _contentEdge = UIEdgeInsetsZero;
    _allBtns = NSMutableArray.array;
    _allSpaces = NSMutableArray.array;
    _markColor = kZCBlackDE;
    _currentTapIndex = -1;
    _selectItemIndex = -1;
    _targetScrollIndex = -1;
    _isShieldSelect = NO;
}

- (void)initialload {
    [self initBarUI];
    [self joinSubview];
}

- (void)reloadItems:(NSArray *)items {
    [self initItems:items];
    [self initItemUI];
    [self reloadLayout];
}

- (void)initItems:(NSArray *)items {
    if (!_items) _items = [[NSMutableArray alloc] initWithCapacity:items.count];
    [_items removeAllObjects];
    for (id item in items) {
        if ([item isKindOfClass:NSString.class]) {
            [_items addObject:[[ZCPartSet alloc] initWithTitle:item]];
        } else if ([item isKindOfClass:ZCPartSet.class]) {
            [_items addObject:item];
        } else {
            [_items addObject:[[ZCPartSet alloc] initWithTitle:@""]]; NSAssert(0, @"ZCKit: item is fail");
        }
    }
    for (int i = 0; i < _items.count; i ++) {
        ZCPartSet *item = _items[i];
        if (!_isFixItemWid) [item calcelateSelectWidth];
        if (self.delegate && [self.delegate respondsToSelector:@selector(partControl:didInitialPartSet:index:)]) {
            [self.delegate partControl:self didInitialPartSet:item index:i];
        }
    }
}

- (void)reloadLayout {
    [self layoutSubviews];
    [self selectToIndex:self.selectItemIndex animated:YES];
}

#pragma mark - System func
- (void)dealloc {
    [self releaseAssociateScrollView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        if (_scrollView) [self releaseAssociateScrollView];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kvo_observe_offset] && object == _scrollView && context == kvo_context_offset) {
        CGFloat offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].x;
        [self scrollViewChangeOffset:offset];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Private func
- (void)selectToIndex:(NSInteger)selectIndex animated:(BOOL)animated {
    BOOL change = self.selectItemIndex != selectIndex;
    if (selectIndex == -1) {
        if (self.isObserver) {
            if (self.items.count) {
                self.currentTapIndex = 0;
                [self selectToIndex:0 animated:animated];
            }
        } else {
            _markView.hidden = YES;
            [self barScrollToIndex:selectIndex animated:animated];
        }
    } else {
        if (self.items.count == 0) {
            self.currentTapIndex = -1;
            [self selectToIndex:-1 animated:animated]; return;
        }
        _markView.hidden = NO;
        if (selectIndex >= self.items.count || selectIndex < 0) {
            selectIndex = 0; change = YES;
        }
        if (_scrollView) {
            if (_scrollView.contentOffset.x == selectIndex * _scrollView.zc_width) {
                [self scrollViewChangeOffset:_scrollView.contentOffset.x];
            }
            [_scrollView setContentOffset:CGPointMake(selectIndex * _scrollView.zc_width, 0) animated:animated];
        } else {
            [self barScrollToIndex:selectIndex animated:animated];
        }
    }
    if (change && selectIndex != -1) {
        if (self.onSelectIndex) {
            self.onSelectIndex(selectIndex);
        }
    }
}

- (void)associateScrollView:(ZCScrollView *)scrollView {
    [self releaseAssociateScrollView];
    self.scrollView = scrollView;
    [scrollView addObserver:self forKeyPath:kvo_observe_offset options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:kvo_context_offset];
    self.isObserver = YES;
    if (self.selectItemIndex >= 0 && self.selectItemIndex < self.items.count) {
        self.currentTapIndex = self.selectItemIndex;
        [self selectToIndex:self.selectItemIndex animated:NO];
    } else if (self.items.count) {
        self.currentTapIndex = 0;
        [self selectToIndex:0 animated:NO];
    } else {
        self.currentTapIndex = -1;
        [self selectToIndex:-1 animated:NO];
    }
}

- (void)releaseAssociateScrollView {
    if (self.scrollView && self.isObserver) {
        [self.scrollView removeObserver:self forKeyPath:kvo_observe_offset context:kvo_context_offset];
        self.isObserver = NO;
    }
}

- (void)shieldOnceSelectIndexDidChange {
    self.isShieldSelect = YES;
}

- (nullable ZCButton *)barButtonWithIndex:(NSInteger)index {
    return [self.allBtns objectOrNilAtIndex:index];
}

#pragma mark - Tool func
- (void)barScrollToIndex:(NSInteger)index animated:(BOOL)animate {
    if (index != -1) {
        CGFloat setx = self.barView.contentOffset.x;
        CGFloat offx = [self totalWidthToIndex:index];
        CGFloat barHalf = self.barView.zc_width / 2.0;
        CGFloat itemHalf = self.items[index].itemSelCalwid / 2.0 + _interval;
        if ((offx + _alphaOffset + itemHalf > barHalf) && (offx + _alphaOffset + itemHalf + barHalf < self.barView.contentSize.width)) {
            setx = offx + _alphaOffset + itemHalf - barHalf;
        } else if (offx + _alphaOffset + itemHalf + barHalf >= self.barView.contentSize.width) {
            setx = self.barView.contentSize.width - self.barView.zc_width;
        } else if (offx + _alphaOffset + itemHalf <= barHalf) {
            setx = 0;
        }
        if (setx < 0) setx = 0;
        [self.barView setContentOffset:CGPointMake(setx, 0) animated:animate];
        [self buttonSelect:NO index:self.selectItemIndex touch:YES resetColor:NO];
        self.selectItemIndex = index;
        [self buttonSelect:YES index:self.selectItemIndex touch:YES resetColor:NO];
    } else {
        self.selectItemIndex = index;
        for (int i = 0; i < self.allBtns.count; i ++) {
            [self buttonSelect:NO index:i touch:YES resetColor:NO];
        }
    }
}

- (void)scrollViewChangeOffset:(CGFloat)offset {
    NSInteger page = round(offset / _scrollView.zc_width);
    if (page != self.selectItemIndex && page >= 0 && page < self.items.count) {
        CGFloat setx = self.barView.contentOffset.x;
        CGFloat offx = [self totalWidthToIndex:page];
        CGFloat barHalf = self.barView.zc_width / 2.0;
        CGFloat itemHalf = self.items[page].itemSelCalwid / 2.0 + _interval;
        if ((offx + _alphaOffset + itemHalf > barHalf) && (offx + _alphaOffset + itemHalf + barHalf < self.barView.contentSize.width)) {
            setx = offx + _alphaOffset + itemHalf - barHalf;
        } else if (offx + _alphaOffset + itemHalf + barHalf >= self.barView.contentSize.width) {
            setx = self.barView.contentSize.width - self.barView.zc_width;
        } else if (offx + _alphaOffset + itemHalf <= barHalf) {
            setx = 0;
        }
        if (setx < 0) setx = 0;
        if (self.targetScrollIndex == -1 || self.targetScrollIndex == page) {
            [self.barView setContentOffset:CGPointMake(setx, 0) animated:YES]; self.targetScrollIndex = -1;
        }
        [self buttonSelect:NO index:self.selectItemIndex touch:NO resetColor:NO];
        self.selectItemIndex = page;
        [self buttonSelect:YES index:self.selectItemIndex touch:NO resetColor:NO];
    }
    
    NSInteger ws, cs = self.selectItemIndex;
    CGFloat mscal = (offset + _scrollView.zc_width / 2.0 - self.selectItemIndex * _scrollView.zc_width) / _scrollView.zc_width;
    if (offset > _scrollView.zc_width * self.selectItemIndex) {
        ws = ceilf(offset / _scrollView.zc_width);
    } else if (offset < _scrollView.zc_width * self.selectItemIndex) {
        ws = floorf(offset / _scrollView.zc_width);
    } else {
        ws = cs;
    }
    if (ws != cs) {
        ZCButton *cb = [self buttonWithIndex:cs];
        ZCButton *wb = [self buttonWithIndex:ws];
        CGFloat var = 1.0 - ABS(ws - offset / _scrollView.zc_width);
        if (cb) [cb setTitleColor:[self colorForVar:var index:cs] forState:UIControlStateSelected];
        if (wb) [wb setTitleColor:[self colorForVar:(1.0 - var) index:ws] forState:UIControlStateNormal];
        [self resetMarkRect:cs to:ws scal:mscal var:var];
    } else {
        [self resetMarkRect:cs to:ws scal:mscal var:0];
        for (int i = 0; i < self.allBtns.count; i ++) {
            [self buttonSelect:(i == cs) index:i touch:NO resetColor:YES];
        }
    }
}

- (void)buttonSelect:(BOOL)select index:(NSInteger)index touch:(BOOL)touch resetColor:(BOOL)resetColor {
    ZCButton *btn = [self buttonWithIndex:index];
    if (btn) {
        btn.selected = select;
        if (select) {
            btn.titleLabel.font = self.items[index].selectTitleFont;
            if (touch) {
                CGFloat hei = self.zc_height - _contentEdge.top - _contentEdge.bottom;
                CGSize size = self.items[index].itemSelMarkSize;
                CGRect fromRect = self.markView.frame;
                self.markView.zc_size = size;
                self.markView.zc_centerX = btn.zc_centerX;
                self.markView.zc_top = _isBottomMark ? (hei - size.height) : (hei - size.height) / 2.0;
                if (self.delegate && [self.delegate respondsToSelector:@selector(partControl:didMoveMark:from:to:index:)]) {
                    [self.delegate partControl:self didMoveMark:self.markView from:fromRect to:self.markView.frame index:index];
                }
            }
        } else {
            btn.titleLabel.font = self.items[index].normalTitleFont;
        }
        if (resetColor) {
            [btn setTitleColor:self.items[index].normalColor forState:UIControlStateNormal];
            [btn setTitleColor:self.items[index].selectColor forState:UIControlStateSelected];
        }
    }
}

- (void)resetMarkRect:(NSInteger)fromIndex to:(NSInteger)toIndex scal:(CGFloat)scal var:(float)var {
    CGSize size = CGSizeZero;
    CGFloat midx = 0;
    if (toIndex >= 0 && toIndex < self.items.count && fromIndex >= 0 && fromIndex < self.items.count) {
        ZCPartSet *fromSet = self.items[fromIndex];
        ZCPartSet *toSet = self.items[toIndex];
        midx = [self totalWidthToIndex:fromIndex] + fromSet.itemSelCalwid * scal + _alphaOffset;
        size = CGSizeMake((1.0 - var) * fromSet.itemSelMarkSize.width + var * toSet.itemSelMarkSize.width,
                          (1.0 - var) * fromSet.itemSelMarkSize.height + var * toSet.itemSelMarkSize.height);
    } else if (fromIndex >= 0 && fromIndex < self.items.count) {
        ZCPartSet *fromSet = self.items[fromIndex];
        midx = [self totalWidthToIndex:fromIndex] + fromSet.itemSelCalwid * scal + _alphaOffset;
        size = fromSet.itemSelMarkSize;
    }
    CGFloat hei = self.zc_height - _contentEdge.top - _contentEdge.bottom;
    self.markView.zc_size = size;
    self.markView.zc_centerX = midx + (fromIndex > 0 ? _interval : 0);
    self.markView.zc_top = _isBottomMark ? (hei - size.height) : (hei - size.height) / 2.0;
}

- (UIColor *)colorForVar:(CGFloat)v index:(NSInteger)index {
    if (index >= 0 && index < self.items.count) {
        NSArray *nc = self.items[index].nca;
        NSArray *sc = self.items[index].sca;
        CGFloat R = [sc[0] floatValue] - ([sc[0] floatValue] - [nc[0] floatValue]) * v;
        CGFloat G = [sc[1] floatValue] - ([sc[1] floatValue] - [nc[1] floatValue]) * v;
        CGFloat B = [sc[2] floatValue] - ([sc[2] floatValue] - [nc[2] floatValue]) * v;
        return kZCRGBV(R, G, B, 1.0);
    }
    return nil;
}

- (CGFloat)totalWidthToIndex:(NSInteger)index {
    CGFloat width = 0;
    for (int i = 0; i < _items.count; i ++) {
        if (i == index) break;
        width = width + _items[i].itemSelCalwid + _interval;
    }
    return (width > 0 ? (width - _interval) : width);
}

- (ZCButton *)buttonWithIndex:(NSInteger)index {
    if (index >= 0 && index < self.allBtns.count) {
        return [self.allBtns objectAtIndex:index];
    }
    return nil;
}

- (UIView *)lineWithIndex:(NSInteger)index {
    if (index >= 0 && index < self.allSpaces.count) {
        return [self.allSpaces objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Set & Get
- (void)setSelectItemIndex:(NSInteger)selectItemIndex {
    BOOL isTap = (_currentTapIndex != -1) && (_currentTapIndex == selectItemIndex);
    BOOL isSlid = !isTap && (_currentTapIndex == -1);
    if (_currentTapIndex == selectItemIndex) _currentTapIndex = -1;
    BOOL change = _selectItemIndex != selectItemIndex;
    _selectItemIndex = selectItemIndex;
    if (change) {
        if (!self.isShieldSelect && self.delegate && [self.delegate respondsToSelector:@selector(partControl:selectIndexDidChange:isTouchTrigger:isActiveSlid:)]) {
            [self.delegate partControl:self selectIndexDidChange:_selectItemIndex isTouchTrigger:isTap isActiveSlid:isSlid];
        }
        if (self.isShieldSelect) self.isShieldSelect = NO;
    }
}

- (NSInteger)currentSelectIndex {
    return self.selectItemIndex;
}

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    [self reloadLayout];
}

- (void)setInterval:(CGFloat)interval {
    _interval = interval;
    [self reloadLayout];
}

- (void)setContentEdge:(UIEdgeInsets)contentEdge {
    _contentEdge = contentEdge;
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, contentEdge)) {
        if (_barView) _barView.clipsToBounds = YES;
    } else {
        if (_barView) _barView.clipsToBounds = NO;
    }
    [self reloadLayout];
}

- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;
    _barView.backgroundColor = barColor;
}

- (void)setMarkColor:(UIColor *)markColor {
    _markColor = markColor;
    _markView.backgroundColor = markColor;
}

- (void)setMarkSize:(CGSize)markSize {
    _markSize = markSize;
    [self reloadLayout];
}

- (void)setAlphaImage:(UIImage *)alphaImage {
    _alphaImage = alphaImage;
    _leftAlphaView.hidden = !alphaImage;
    _rightAlphaView.hidden = !alphaImage;
    _alphaOffset = alphaImage ? 8.0 : 0;
    if (alphaImage) {
        _leftAlphaView.image = alphaImage;
        _rightAlphaView.image = alphaImage;
    }
    [self reloadLayout];
}

#pragma mark - Interface
- (void)initBarUI {
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.backgroundColor = kZCClear;
    
    _barView = [[ZCScrollView alloc] initWithFrame:CGRectZero];
    _barView.backgroundColor = _barColor;
    _barView.showsHorizontalScrollIndicator = NO;
    _barView.showsVerticalScrollIndicator = NO;
    _barView.directionalLockEnabled = YES;
    
    _markView = [[UIView alloc] init];
    _markView.backgroundColor = _markColor;
    
    _rightAlphaView = [[ZCImageView alloc] initWithFrame:CGRectZero image:nil];
    _rightAlphaView.transform = CGAffineTransformMakeRotation(M_PI);
    _rightAlphaView.hidden = YES;
    
    _leftAlphaView = [[ZCImageView alloc] initWithFrame:CGRectZero image:nil];
    _leftAlphaView.hidden = YES;
}

- (void)joinSubview {
    [self addSubview:_backgroundView];
    [self addSubview:_barView];
    [self addSubview:_leftAlphaView];
    [self addSubview:_rightAlphaView];
}

- (void)initItemUI {
    [self.barView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.allSpaces removeAllObjects];
    [self.allBtns removeAllObjects];
    for (NSInteger i = 0; i < self.items.count; i ++) {
        ZCPartSet *item = self.items[i];
        ZCButton *button = [[ZCButton alloc] initWithFrame:CGRectZero];
        button.adjustsImageWhenDisabled = NO;
        button.adjustsImageWhenHighlighted = NO;
        if (item.normalAttTitle || item.selectAttTitle) {
            [button setAttributedTitle:item.normalAttTitle forState:UIControlStateNormal];
            [button setAttributedTitle:item.selectAttTitle forState:UIControlStateSelected];
            [button setAttributedTitle:item.normalAttTitle forState:UIControlStateHighlighted|UIControlStateNormal];
            [button setAttributedTitle:item.selectAttTitle forState:UIControlStateHighlighted|UIControlStateSelected];
        } else {
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setTitleColor:item.normalColor forState:UIControlStateNormal];
            [button setTitleColor:item.selectColor forState:UIControlStateSelected];
            [button setTitleColor:item.normalColor forState:UIControlStateHighlighted|UIControlStateNormal];
            [button setTitleColor:item.selectColor forState:UIControlStateHighlighted|UIControlStateSelected];
            button.titleLabel.font = item.normalTitleFont;
        }
        if (item.normalImage) [button setImage:item.normalImage forState:UIControlStateNormal];
        if (item.normalImage) [button setImage:item.normalImage forState:UIControlStateHighlighted|UIControlStateNormal];
        if (item.selectImage) [button setImage:item.selectImage forState:UIControlStateSelected];
        if (item.selectImage) [button setImage:item.selectImage forState:UIControlStateHighlighted|UIControlStateSelected];
        button.responseAreaExtend = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
        button.responseTouchInterval = 0.35;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button resetImageSize:(item.normalImage ? item.imageSize : CGSizeZero) titleSize:CGSizeZero];
        [button addTarget:self action:@selector(onItemBar:) forControlEvents:UIControlEventTouchUpInside];
        UIView *spaceline = [[UIView alloc] init];
        spaceline.backgroundColor = kZCBlackDE;
        [self.barView addSubview:button];
        [self.barView addSubview:spaceline];
        [self.allBtns addObject:button];
        [self.allSpaces addObject:spaceline];
    }
    if (_isBottomMark) {
        if (![self.markView isDescendantOfView:self.barView]) [self.barView addSubview:self.markView];
    } else {
        if (![self.markView isDescendantOfView:self.barView]) [self.barView insertSubview:self.markView atIndex:0];
    }
}

- (void)layoutItemSAI11 {
    if (_isFixItemWid) {
        CGFloat itemwid = 0;
        CGSize itemSize = CGSizeZero;
        CGFloat width = self.zc_width - _contentEdge.left - _contentEdge.right - 2.0 * _alphaOffset;
        CGFloat height = self.zc_height - _contentEdge.top - _contentEdge.bottom;
        NSInteger count = self.items.count;
        if (count) {
            if (self.itemWidth) {
                itemwid = self.itemWidth;
                if (count * itemwid + _interval * (count - 1) <= width) {
                    itemwid = (width + _interval) / count - _interval;
                }
            } else {
                itemwid = (width + _interval) / count - _interval;
            }
        }
        
        if (_markSize.width && _markSize.height) {
            itemSize = _markSize;
        } else if (_markSize.width) {
            itemSize = CGSizeMake(_markSize.width, _isBottomMark ? 2.0 : (height - _markOffset));
        } else if (_markSize.height) {
            if (_isBottomMark) {
                itemSize = (count <= 3) ? CGSizeMake(itemwid, _markSize.height) : CGSizeMake(itemwid - _markOffset, _markSize.height);
            } else {
                itemSize = CGSizeMake(itemwid - _markOffset, _markSize.height);
            }
        } else {
            if (_isBottomMark) {
                itemSize = (count <= 3) ? CGSizeMake(itemwid, 2.0) : CGSizeMake(itemwid - _markOffset, 2.0);
            } else {
                itemSize = CGSizeMake(itemwid - _markOffset, height - _markOffset);
            }
        }
        
        for (ZCPartSet *item in _items) {
            item.itemSelCalwid = MAX(itemwid, 0);
            item.itemSelMarkSize = CGSizeMake(MAX(itemSize.width, 0), MAX(itemSize.height, 0));
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutItemSAI11];
    self.backgroundView.frame = CGRectMake(0, 0, self.zc_width, self.zc_height);
    CGFloat bar_h = self.zc_height - _contentEdge.top - _contentEdge.bottom;
    CGFloat bar_w = self.zc_width - _contentEdge.left - _contentEdge.right;
    self.barView.frame = CGRectMake(_contentEdge.left, _contentEdge.top, bar_w, bar_h);
    self.barView.contentSize = CGSizeMake([self totalWidthToIndex:_items.count] + 2.0 * _alphaOffset, bar_h);
    if (!self.leftAlphaView.hidden) {
        self.leftAlphaView.frame = CGRectMake(0, 0, _alphaOffset, self.zc_height);
    }
    if (!self.rightAlphaView.hidden) {
        self.rightAlphaView.frame = CGRectMake(self.zc_width - _alphaOffset, 0, _alphaOffset, self.zc_height);
    }
    CGFloat add = _alphaOffset;
    for (NSInteger i = 0; i < _items.count; i ++) {
        ZCPartSet *item = _items[i];
        CGFloat mark_h = _isBottomMark ? item.itemSelMarkSize.height : 0;
        UIView *spaceline = [self lineWithIndex:i];
        spaceline.hidden = i == 0;
        if (!spaceline.hidden) spaceline.frame = CGRectMake(add, (bar_h - mark_h - item.spaceHeight) / 2.0, 0.5, item.spaceHeight);
        ZCButton *btn = [self buttonWithIndex:i];
        btn.frame = CGRectMake(add, 0, item.itemSelCalwid, bar_h - mark_h);
        add = add + item.itemSelCalwid + _interval;
    }
}

#pragma mark - Action
- (void)onItemBar:(ZCButton *)btn {
    BOOL isCanTouch = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(partControlCanTouchBarItem:)]) {
        isCanTouch = [self.delegate partControlCanTouchBarItem:self];
    } if (!isCanTouch) return;
    btn.highlighted = NO;
    NSInteger fromIdex = self.selectItemIndex;
    NSInteger aimIndex = [self.allBtns indexOfObject:btn];
    self.currentTapIndex = aimIndex;
    self.targetScrollIndex = aimIndex;
    [self selectToIndex:aimIndex animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(partControl:didSelectItemAtIndex:fromIndex:)]) {
        [self.delegate partControl:self didSelectItemAtIndex:aimIndex fromIndex:fromIdex];
    }
}

@end
