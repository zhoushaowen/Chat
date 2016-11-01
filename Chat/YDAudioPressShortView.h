//
//  YDAudioPressShortView.h
//  Chat
//
//  Created by 周少文 on 2016/10/27.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDAudioPressShortView : UIView

+ (instancetype)audioPressShortView;
- (void)showAndHideWithDelay:(NSTimeInterval)delay;
- (void)hide;

@end
