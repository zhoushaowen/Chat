//
//  YDChatBaseViewController.h
//  Chat
//
//  Created by 周少文 on 2016/10/24.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDChatBottomToolView.h"

@interface YDChatBaseViewController : UIViewController

/**
 设置消息数据

 @param dataArray 消息数组
 */
- (void)setDataArray:(NSArray *)dataArray;

/**
 为某个类型的消息注册某个类型的cell

 @param messageClass 消息的model类型
 @param cellClass 展示的cell类型
 */
- (void)registerMessageClass:(Class)messageClass forCellClass:(Class)cellClass;

/**
 添加一条消息,内部会自动向dataArray中添加一个数据,并刷新UI

 @param message 消息实例
 */
- (void)addMessage:(id)message;

/**
 根据某个索引删除一条消息,内部会自动从dataArray中删除一个数据,并刷新UI

 @param index 消息的索引
 */
- (void)deleteMessageAtIndex:(NSInteger)index;
/**
 删除一条消息,内部会自动从dataArray中删除一个数据,并刷新UI
 
 @param message 消息实例
 */
- (void)deleteMessage:(id)message;

- (void)sendMessageButtonClick:(NSString *)text;
- (void)chatBottomToolView:(YDChatBottomToolView *)toolView actionItemClick:(id<YDActionItemProtocol>)item;

@end

