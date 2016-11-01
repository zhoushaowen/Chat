//
//  YDMessageCell.h
//  chatList
//
//  Created by r_zhou on 2016/10/24.
//  Copyright © 2016年 r_zhous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface YDMessageCell : UITableViewCell
@property (strong, nonatomic) UIImageView *headerImgV;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *bubbleImgV;
//@property (strong, nonatomic) NSDictionary *dictionary;
/**
 *  isSender YES 发送方   NO 接收方
 **/
@property (assign, nonatomic) BOOL isSender;
/**
 *  isTime YES 表示显示事件   NO 其他表示不显示
 **/
@property (assign, nonatomic) BOOL isTime;

@property (nonatomic,strong) id contentModel;
@property (nonatomic,readonly) CGFloat rowHeight;

- (void)setupUI;
- (void)updateCellLayout;

@end
