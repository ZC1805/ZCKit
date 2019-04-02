//
//  JFTableViewCell.m
//  gobe
//
//  Created by zjy on 2019/3/16.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFTableViewCell.h"

@implementation JFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UIView *)topSepLineView {
    if (!_topSepLineView) {
        _topSepLineView = [[UIView alloc] initWithFrame:CGRectZero color:ZCSPColor];
        [self.contentView addSubview:_topSepLineView];
        [_topSepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.equalTo(@ZSSepHei);
        }];
    }
    return _topSepLineView;
}

- (UIView *)bottomSepLineView {
    if (!_bottomSepLineView) {
        _bottomSepLineView = [[UIView alloc] initWithFrame:CGRectZero color:ZCSPColor];
        [self.contentView addSubview:_bottomSepLineView];
        [_bottomSepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@ZSSepHei);
        }];
    }
    return _bottomSepLineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
