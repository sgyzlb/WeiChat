//
//  HYMessageTableViewCell.h
//  WeiChat
//
//  Created by 邱扬 on 14-3-25.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMessage.h"

@interface HYMessageTableViewCell : UITableViewCell

@property (nonatomic, assign) HYMainMessage *mainMessage;

@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UIButton *textBtn;

@end
