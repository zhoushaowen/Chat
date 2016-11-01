//
//  YDCancelSendView.m
//  Chat
//
//  Created by 周少文 on 2016/10/26.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "YDCancelSendView.h"
#import "UIImage+Bundle.h"
#import "UIView+SWAutoLayout.h"
#import "UIColor+Hex.h"
#import "UIView+HUD.h"

@implementation YDCancelSendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithBundleName:@"chat" imageName:@"return"]];
        imageView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        [self addSubview:imageView];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        [self addSubview:label];
        [label sw_addConstraintWith:NSLayoutAttributeTop toView:imageView attribute:NSLayoutAttributeBottom constant:0];
        [label sw_addConstraintToView:self withEqualAttribute:NSLayoutAttributeCenterX constant:0];
        [label sw_addConstraintsWithFormat:@"H:[label(144)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)];
        [label sw_addConstraintsWithFormat:@"V:[label(24)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)];
        label.text = @"松开手手指，取消发送";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [[UIColor colorWithHexString:@"FD686A"] colorWithAlphaComponent:0.8f];
    }
    
    return self;
}

+ (instancetype)cancelSendView
{
    YDCancelSendView *view = [[self alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    return view;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow showHUDWithCustomView:self];
}

- (void)hide
{
    [[UIApplication sharedApplication].keyWindow hideHUD];
}


@end
