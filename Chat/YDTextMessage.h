//
//  YDTextMessage.h
//  Chat
//
//  Created by 周少文 on 2016/10/31.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDTextMessage : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *timeStr;

//是否是消息接收方
@property (nonatomic) BOOL isReceiver;

//是否显示时间
@property (nonatomic,getter=isDisplayTime) BOOL displayTime;

@end
