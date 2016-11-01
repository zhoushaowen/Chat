//
//  YDTextMessageCell.m
//  chatList
//
//  Created by r_zhou on 2016/10/28.
//  Copyright © 2016年 r_zhous. All rights reserved.
//

#import "YDTextMessageCell.h"
#import "YDBaseMessage.h"

@interface YDTextMessageCell()
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation YDTextMessageCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.contentLab = [[UILabel alloc] init];
        self.contentLab.backgroundColor = [UIColor redColor];
        self.contentLab.font = [UIFont systemFontOfSize:15];
        self.contentLab.numberOfLines = 0;
        [self.bubbleImgV addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-10);
        }];
        self.contentLab.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 172/2.0f - 140/2.0f;
    }
    return self;
}

//- (void)setDictionary:(NSDictionary *)dictionary
//{
//}

- (void)setContentModel:(id)contentModel
{
    [super setContentModel:contentModel];
    YDBaseMessage *message = contentModel;
    
    self.isTime = message.isDisplayTime;
    self.isSender = !message.isReceiver;
    
    [self updateCellLayout];
    
    if (self.isSender) {
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-17);
            make.bottom.mas_equalTo(-10);
        }];
    } else {
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    self.contentLab.text = message.content;
    self.timeLabel.text = message.timeStr;
    self.nameLabel.text = message.name;
}

- (CGFloat)calculateRowHeight:(NSDictionary *)model
{
    self.contentModel = model;
    [self layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.bubbleImgV.frame) + 15;
    return height;
}

- (CGFloat)rowHeightWithModel:(id)model
{
    return [self calculateRowHeight:model];
}



@end
