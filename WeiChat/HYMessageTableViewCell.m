//
//  HYMessageTableViewCell.m
//  WeiChat
//
//  Created by 邱扬 on 14-3-25.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#import "HYMessageTableViewCell.h"

@implementation HYMessageTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置table   防止table背景被遮挡
        self.backgroundColor = [UIColor clearColor];
        //创建时间
        _timeBtn = [[UIButton alloc] init];
        _timeBtn.titleLabel.font = TimeFont;
        _timeBtn.enabled = NO;   //设置不能按
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"timeline_bg"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        //创建头像
        _iconImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImg];
        //创建内容
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textBtn.titleLabel.font = TextFont;
        _textBtn.titleLabel.numberOfLines = 0;
        [_textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_textBtn];
    }
    return self;
}

- (void)setMainMessage:(HYMainMessage *)mainMessage {
    _mainMessage = mainMessage;
    HYMessage *message = _mainMessage.message;
    //设置时间
    [_timeBtn setTitle:message.time forState:UIControlStateNormal];
    _timeBtn.frame = mainMessage.timeRect;
    //设置头像
    _iconImg.image = [UIImage imageNamed:message.icon];
    _iconImg.frame = mainMessage.iconRect;
    //设置内容
    [_textBtn setTitle:message.text forState:UIControlStateNormal];
    _textBtn.contentEdgeInsets = UIEdgeInsetsMake(TextTop, TextLeft, TextBottom, TextRight);
    _textBtn.frame = mainMessage.textRect;
    
    //根据接受 或者 发送设置text
    UIImage *tempImg;
    if (message.type == MessageForMe) {
        _textBtn.contentEdgeInsets = UIEdgeInsetsMake(TextTop, TextRight, TextBottom, TextLeft);
        tempImg = [UIImage imageNamed:@"chatforme_normal"];
        //设置不拉伸地点
        [_textBtn setBackgroundImage:[tempImg stretchableImageWithLeftCapWidth:tempImg.size.width * 0.5 topCapHeight:tempImg.size.height * 0.7] forState:UIControlStateNormal];
        tempImg = [UIImage imageNamed:@"chatforme_focused"];
        [_textBtn setBackgroundImage:[tempImg stretchableImageWithLeftCapWidth:tempImg.size.width * 0.5 topCapHeight:tempImg.size.height * 0.7] forState:UIControlStateHighlighted];
    } else {
        tempImg = [UIImage imageNamed:@"chattome_normal"];
        [_textBtn setBackgroundImage:[tempImg stretchableImageWithLeftCapWidth:tempImg.size.width * 0.5 topCapHeight:tempImg.size.height * 0.7] forState:UIControlStateNormal];
        tempImg = [UIImage imageNamed:@"chattome_focused"];
        [_textBtn setBackgroundImage:[tempImg stretchableImageWithLeftCapWidth:tempImg.size.width * 0.5 topCapHeight:tempImg.size.height * 0.7] forState:UIControlStateHighlighted];
    }
    
}

@end
