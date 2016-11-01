//
//  YDChatBottomToolView.h
//  ChatBottom
//
//  Created by 周少文 on 2016/10/24.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDEmojiKeyboardView.h"
#import "YDChatPlusView.h"
#import "YDRecordingView.h"
#import "YDCancelSendView.h"
#import "YDAudioPressShortView.h"

@class YDChatBottomToolView;

@protocol YDChatBottomToolViewDelegate <NSObject>

@required

- (void)chatBottomToolView:(YDChatBottomToolView *)toolView textViewTextDidChange:(UITextView *)textView;
- (void)chatBottomToolView:(YDChatBottomToolView *)toolView keyboardWillChangeFrameNotification:(NSNotification *)notification;
- (void)chatBottomToolView:(YDChatBottomToolView *)toolView didClickSendButton:(NSString *)text;
- (void)chatBottomToolView:(YDChatBottomToolView *)toolView actionItemClick:(id<YDActionItemProtocol>)item;


@end

@interface YDChatBottomToolView : UIView

@property (nonatomic,strong,readonly) UITextView *textView;
@property (nonatomic,strong,readonly) YDEmojiKeyboardView *emojiKeyboardView;
@property (nonatomic,strong,readonly) YDChatPlusView *plusView;
@property (nonatomic,strong) id<YDChatBottomToolViewDelegate> delegate;
@property (nonatomic,strong) YDRecordingView *recordingView;
@property (nonatomic,strong) YDCancelSendView *cancelSendView;
@property (nonatomic,strong) YDAudioPressShortView *audioPressShortView;
@property (nonatomic) NSUInteger audioPressShortSecond;
- (void)resignTextViewFirstResponder;


@end
