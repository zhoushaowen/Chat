//
//  YDChatViewController.m
//  Chat
//
//  Created by 周少文 on 2016/10/31.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "YDChatViewController.h"
#import "YDTextMessageCell.h"
#import "YDTextMessage.h"

@interface YDChatViewController ()

@end

@implementation YDChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerMessageClass:[YDTextMessage class] forCellClass:[YDTextMessageCell class]];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0;i<20;i++)
    {
        YDTextMessage *message = [YDTextMessage new];
        message.content = @"啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
        message.name = @"张三";
        [arr addObject:message];
    }
    [self setDataArray:arr];
}


- (void)sendMessageButtonClick:(NSString *)text
{
    YDTextMessage *message = [YDTextMessage new];
    message.content = text;
    message.name = @"李四";
    [self addMessage:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
