//
//  ZCFlowSectionLayout.m
//  ZCKit
//
//  Created by admin on 2019/1/11.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCFlowSectionLayout.h"
#import "NSArray+ZC.h"

@interface ZCFlowSectionLayout ()
@property (nonatomic, assign) CGFloat i_w;
@property (nonatomic, assign) CGFloat sh_w;
@property (nonatomic, assign) CGFloat add_hei;
@property (nonatomic, assign) BOOL is_stop_line;

@property (nonatomic, assign) CGFloat i_h;
@property (nonatomic, assign) CGFloat sh_h;
@property (nonatomic, assign) CGFloat hor_space;
@property (nonatomic, assign) CGFloat ver_space;
@property (nonatomic, assign) UIEdgeInsets s_insets;
@property (nonatomic, assign) CGFloat additional_hei;

@property (nonatomic, assign) int line_count;
@property (nonatomic, assign) BOOL isHorLayout;
@property (nonatomic, assign) CGFloat container_w;

@property (nonatomic, strong) NSArray <UICollectionViewLayoutAttributes *>*sh_atts;
@property (nonatomic, strong) NSArray < NSArray <UICollectionViewLayoutAttributes *>*>*s_atts;
@end

@implementation ZCFlowSectionLayout

- (instancetype)initWithContainerWidth:(CGFloat)containerWidth lineCount:(int)lineCount isHorLayout:(BOOL)isHorLayout {
    if (self = [super init]) {
        self.line_count = lineCount;
        self.isHorLayout = isHorLayout;
        self.container_w = containerWidth;
        self.additional_hei = 0;
    }
    return self;
}

- (void)resetHorSpace:(CGFloat)horSpace verSpace:(CGFloat)verSpace sectionInsets:(UIEdgeInsets)sectionInsets itemHei:(CGFloat)itemHei sectionHeaderHei:(CGFloat)sectionHeaderHei {
    self.hor_space = horSpace;
    self.ver_space = verSpace;
    self.s_insets = sectionInsets;
    self.i_h = itemHei;
    self.sh_h = sectionHeaderHei;
}

- (void)resetAdditionalHei:(CGFloat)additionalHei {
    self.additional_hei = additionalHei;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.sh_w = self.container_w - self.s_insets.left - self.s_insets.right;
    self.i_w = (self.sh_w - self.hor_space * (self.line_count - 1))/self.line_count;
    self.is_stop_line = YES;
    self.add_hei = 0;
    _itemSize = CGSizeMake(self.i_w, self.i_h);
    _sectionHeaderSize = CGSizeMake(self.sh_w, self.sh_h);
    self.s_atts = [NSMutableArray array];
    self.sh_atts = [NSMutableArray array];
    NSInteger sections = [self.collectionView numberOfSections];
    for (int s = 0; s < sections; s ++) {
        NSMutableArray *i_atts = [NSMutableArray array];
        NSInteger items = [self.collectionView numberOfItemsInSection:s];
        [(NSMutableArray *)self.s_atts addObject:i_atts];
        [(NSMutableArray *)self.sh_atts addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathWithIndex:s]]];
        for (int i = 0; i < items; i ++) {
            [i_atts addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:s]]];
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)idxp {
    NSArray *i_atts = [self.s_atts objectOrNilAtIndex:idxp.section];
    if (!i_atts) return [super layoutAttributesForItemAtIndexPath:idxp];
    UICollectionViewLayoutAttributes *i_att = [i_atts objectOrNilAtIndex:idxp.item];
    if (i_att) return i_att;
    i_att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:idxp];
    if (self.isHorLayout) {
        CGFloat x = self.container_w * idxp.section + self.s_insets.left + (idxp.item % self.line_count) * (self.i_w + self.hor_space);
        CGFloat y = self.s_insets.top + self.sh_h + (idxp.item / self.line_count) * (self.i_h + self.ver_space);
        i_att.frame = CGRectMake(x, y, self.i_w, self.i_h);
        self.add_hei = MAX(self.add_hei, y + self.i_h);
    } else {
        CGFloat x = self.s_insets.left + (idxp.item % self.line_count) * (self.i_w + self.hor_space);
        CGFloat y = self.add_hei + (idxp.item >= self.line_count ? self.ver_space : 0);
        i_att.frame = CGRectMake(x, y, self.i_w, self.i_h);
        self.is_stop_line = self.line_count < 2 || (idxp.item % self.line_count == self.line_count - 1);
        self.add_hei = y + (self.is_stop_line ? self.i_h : 0);
    }
    return i_att;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSInteger index = [indexPath indexAtPosition:0];
        UICollectionViewLayoutAttributes *sh_att = [self.sh_atts objectOrNilAtIndex:index];
        if (sh_att) return sh_att;
        sh_att = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        if (self.isHorLayout) {
            sh_att.frame = CGRectMake(self.s_insets.left + self.container_w * index, self.s_insets.top, self.sh_w, self.sh_h);
            self.add_hei = MAX(self.add_hei, self.s_insets.top + self.sh_h);
        } else {
            CGFloat sh_t = self.add_hei + (index > 0 ? self.s_insets.bottom : 0) + (self.is_stop_line ? 0 : self.i_h) + self.s_insets.top;
            sh_att.frame = CGRectMake(self.s_insets.left, sh_t, self.sh_w, self.sh_h);
            self.add_hei = sh_t + self.sh_h;
        }
        return sh_att;
    } else {
        return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
}

- (NSArray <UICollectionViewLayoutAttributes *>*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *atts = [NSMutableArray array];
    [atts addObjectsFromArray:self.sh_atts];
    for (NSArray *i_atts in self.s_atts) { [atts addObjectsFromArray:i_atts]; }
    return atts.copy;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    if (self.isHorLayout) {
        CGFloat hei = self.add_hei + self.s_insets.bottom;
        return CGSizeMake(self.container_w * self.sh_atts.count, hei + self.additional_hei);
    } else {
        CGFloat hei = self.add_hei + self.s_insets.bottom + (self.is_stop_line ? 0 : self.i_h);
        return CGSizeMake(self.container_w, hei + self.additional_hei);
    }
}

@end
