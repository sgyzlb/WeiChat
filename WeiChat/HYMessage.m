//
//  HYMessage.m
//  WeiChat
//
//  Created by 邱扬 on 14-3-25.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#import "HYMessage.h"

@implementation HYMessage

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    _text = dict[@"text"];
    _time = dict[@"time"];
    _icon = dict[@"icon"];
    _type = [dict[@"type"] intValue];
}

@end

@implementation HYMainMessage

- (void)setMessage:(HYMessage *)message {
    _message = message;
    
    //获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    //计算显示时间
    if (_showTime) {
        CGSize timeSize = [_message.time sizeWithAttributes:@{NSFontAttributeName: TimeFont}];
        CGFloat timeX = (screenW - timeSize.width) / 2;  //对称  除2
        CGFloat timeY = MainMargin;
        _timeRect = CGRectMake(timeX, timeY, timeSize.width + TimeMarginW, timeSize.height + TimeMarginH);
    }
    //计算显示头像
    CGFloat iconX = MainMargin;
    //是否自己发的消息  自己发的头像位于右边
    if (_message.type == MessageForMe) {
        iconX = screenW - ICON - MainMargin;
    }
    CGFloat iconY = CGRectGetMaxY(_timeRect) + MainMargin;
    _iconRect = CGRectMake(iconX, iconY, ICON, ICON);
    //计算显示内容  与icon同步
    CGFloat textX = CGRectGetMaxX(_iconRect) + MainMargin;
    CGFloat textY = iconY;
    
    CGRect textRect = [_message.text boundingRectWithSize:CGSizeMake(TextW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: TextFont} context:nil];
    if (_message.type == MessageForMe) {
        //计算我发给别人的时候的x的坐标
        textX = iconX - MainMargin - textRect.size.width - TextLeft - TextRight;
    }
    _textRect = CGRectMake(textX, textY, textRect.size.width + TextLeft + TextRight, textRect.size.height + TextTop + TextBottom);
    //计算cell高度
    _cellHeight = MAX(CGRectGetMaxY(_iconRect), CGRectGetMaxY(_textRect)) + MainMargin;
    
}

@end