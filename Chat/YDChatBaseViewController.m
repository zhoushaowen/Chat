//
//  YDChatBaseViewController.m
//  Chat
//
//  Created by 周少文 on 2016/10/24.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "YDChatBaseViewController.h"
#import "UIView+SWAutoLayout.h"
#import "UIViewController+Authorization.h"
#import <AVFoundation/AVFoundation.h>
#import "YDTextMessageCell.h"
#import "YDTextMessage.h"
#import <objc/runtime.h>

extern CGFloat const YDKeyboardHeight;
#define YDBottomToolViewOriginalHeight 49

@interface YDChatBaseViewController ()<
UITableViewDelegate,
UITableViewDataSource,
YDChatBottomToolViewDelegate,
UIGestureRecognizerDelegate,
UITableViewDataSourcePrefetching>
{
    UITableView *_tableView;
    YDChatBottomToolView *_bottomToolView;
    NSLayoutConstraint *_bottomToolHeightConstraint;
    NSLayoutConstraint *_bottomToolBottomConstraint;
    CGFloat _bottomToolTextViewTextOriginalHeight;
    NSInteger _keyboardAnimationCurver;
}

@property (nonatomic,strong) NSCache *rowHeightCache;
@property (nonatomic,strong) NSMutableArray *messageTypes;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation YDChatBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if([[UIDevice currentDevice].systemVersion doubleValue] > 10.0f)
    {
        _tableView.prefetchDataSource = self;
    }
#else
    
#endif
    [self.view addSubview:_tableView];
    
    _bottomToolView = [[YDChatBottomToolView alloc] initWithFrame:CGRectZero];
    _bottomToolView.delegate = self;
    [self.view addSubview:_bottomToolView];
    [_bottomToolView sw_addConstraintsWithFormat:@"H:|-0-[_bottomToolView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomToolView)];
    NSArray<NSLayoutConstraint *> *bottomToolVConstraints = [_bottomToolView sw_addConstraintsWithFormat:@"V:[_bottomToolView(h)]-0-|" options:0 metrics:@{@"h":@(YDBottomToolViewOriginalHeight)} views:NSDictionaryOfVariableBindings(_bottomToolView)];
    _bottomToolHeightConstraint = [bottomToolVConstraints firstObject];
    _bottomToolBottomConstraint = [bottomToolVConstraints lastObject];
    _bottomToolTextViewTextOriginalHeight = YDBottomToolViewOriginalHeight - 8*2;
    [_tableView sw_addConstraintsWithFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)];
    [_tableView sw_addConstraintsWithFormat:@"V:|-0-[_tableView]-0-[_bottomToolView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView,_bottomToolView)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataArray[indexPath.row];
    const char * classCString = object_getClassName(model);
    NSString *className = [NSString stringWithCString:classCString encoding:NSUTF8StringEncoding];

    YDTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[className stringByAppendingString:@"-YDChatCell"] forIndexPath:indexPath];
    cell.contentModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    CGFloat height = [[self.rowHeightCache objectForKey:key] doubleValue];
    if(height)
    {
        return height;
    }
    id model = self.dataArray[indexPath.row];
    const char * classCString = object_getClassName(model);
    NSString *className = [NSString stringWithCString:classCString encoding:NSUTF8StringEncoding];
    YDTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[className stringByAppendingString:@"-YDChatCell"]];
    height = [cell rowHeightWithModel:model];
    [self.rowHeightCache setObject:@(height) forKey:key];
    return height;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_bottomToolView resignTextViewFirstResponder];
}

#pragma mark - UITableViewDataSourcePrefetching

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
        CGFloat height = [[self.rowHeightCache objectForKey:key] doubleValue];
        if(height)
        {
            return;
        }
        id model = self.dataArray[indexPath.row];
        const char * classCString = object_getClassName(model);
        NSString *className = [NSString stringWithCString:classCString encoding:NSUTF8StringEncoding];
        YDTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[className stringByAppendingString:@"-YDChatCell"]];
        height = [cell rowHeightWithModel:model];
        [self.rowHeightCache setObject:@(height) forKey:key];
    }];
    
}
#else

#endif

#pragma mark - YDChatBottomToolViewDelegate
- (void)chatBottomToolView:(YDChatBottomToolView *)toolView textViewTextDidChange:(UITextView *)textView
{
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width - textView.textContainerInset.left - textView.textContainerInset.right - textView.textContainer.lineFragmentPadding*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textView.font} context:nil];
    CGFloat height = ceil(rect.size.height);
    UIEdgeInsets insets = textView.textContainerInset;
    if(height < 100)
    {
        if(height > _bottomToolTextViewTextOriginalHeight)
        {
            insets.top = 0;
            insets.bottom = 0;
            textView.textContainerInset = insets;
            textView.contentOffset = CGPointZero;
            _bottomToolHeightConstraint.constant = height + 8*2 + textView.textContainerInset.top + textView.textContainerInset.bottom;
        }else{
            insets.top = 8;
            insets.bottom = 8;
            textView.textContainerInset = insets;
            _bottomToolHeightConstraint.constant = YDBottomToolViewOriginalHeight;
        }
    }else{
        insets.top = 0;
        insets.bottom = 0;
        textView.textContainerInset = insets;
        _bottomToolHeightConstraint.constant = 100;
    }
    [UIView animateWithDuration:0.25f animations:^{
        [UIView setAnimationCurve:_keyboardAnimationCurver];
        [_bottomToolView layoutIfNeeded];
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
    }];

}

- (void)chatBottomToolView:(YDChatBottomToolView *)toolView keyboardWillChangeFrameNotification:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    CGFloat offY = [UIScreen mainScreen].bounds.size.height - [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    _bottomToolBottomConstraint.constant = offY;
    _keyboardAnimationCurver = [dic[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    if(offY == 0)//键盘下落
    {
        _bottomToolHeightConstraint.constant = YDBottomToolViewOriginalHeight;
    }else{//键盘弹起
        [self chatBottomToolView:toolView textViewTextDidChange:toolView.textView];
    }
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [UIView setAnimationCurve:_keyboardAnimationCurver];
        [self.view layoutIfNeeded];
        [_bottomToolView layoutIfNeeded];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_tableView numberOfRowsInSection:0] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];

}

- (void)chatBottomToolView:(YDChatBottomToolView *)toolView didClickSendButton:(NSString *)text
{
    [self sendMessageButtonClick:text];
}

- (void)chatBottomToolView:(YDChatBottomToolView *)toolView actionItemClick:(id<YDActionItemProtocol>)item
{
    if([item.titleName isEqualToString:@"照片"])
    {
        if(![self isHavePhotoLibarayAuthorization])
            return;
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else if([item.titleName isEqualToString:@"拍照"])
    {
        if(![self isHaveCameraAuthorization])
            return;
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            return;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else if([item.titleName isEqualToString:@"定位"])
    {
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_bottomToolView resignTextViewFirstResponder];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self reloadTableView];
}

#pragma mark - Public
- (void)sendMessageButtonClick:(NSString *)text
{
    NSAssert(NO, @"要发送消息子类必须重写- (void)sendMessageButtonClick:(NSString *)text方法");
}

- (void)addMessage:(id)message
{
    NSMutableArray *mutableArr = nil;
    if(self.dataArray)
    {
        mutableArr = [self.dataArray mutableCopy];
    }else{
        mutableArr = [NSMutableArray arrayWithCapacity:0];
    }
    [mutableArr addObject:message];
    _dataArray = mutableArr;
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mutableArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_tableView numberOfRowsInSection:0] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)reloadTableView
{
    [self.rowHeightCache removeAllObjects];
    [_tableView reloadData];
}

- (void)deleteMessageAtIndex:(NSInteger)index
{
    if(self.dataArray == nil)
        return;
    NSMutableArray *arr = [self.dataArray mutableCopy];
    [arr removeObjectAtIndex:index];
    _dataArray = arr;
    [self.rowHeightCache removeAllObjects];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

- (void)deleteMessage:(id)message
{
    if(message == nil)
        return;
    NSInteger index = [_dataArray indexOfObject:message];
    [self deleteMessageAtIndex:index];
}

- (void)registerMessageClass:(Class)messageClass forCellClass:(Class)cellClass
{
    const char *messageClassCString = class_getName(messageClass);
    NSString *cellClassName = [NSString stringWithCString:messageClassCString encoding:NSUTF8StringEncoding];
    [_tableView registerClass:cellClass forCellReuseIdentifier:[cellClassName stringByAppendingString:@"-YDChatCell"]];
}

- (NSCache *)registerClass
{
    if(!_rowHeightCache)
    {
        _rowHeightCache = [[NSCache alloc] init];
    }
    return _rowHeightCache;
}

- (NSMutableArray *)messageTypes
{
    if(!_messageTypes)
    {
        _messageTypes = [NSMutableArray arrayWithCapacity:0];
    }
    return _messageTypes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
