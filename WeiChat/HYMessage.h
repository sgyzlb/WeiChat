//
//  HYMessage.h
//  WeiChat
//
//  Created by 邱扬 on 14-3-25.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#define MainMargin 10  //主间隔

//字体大小
#define TextFont [UIFont systemFontOfSize:16]
#define TimeFont [UIFont systemFontOfSize:12]

#define TimeMarginW 15   //预留宽度
#define TimeMarginH 10   //预留高度

#define ICON 40

#define TextW 180
#define TextLeft 20
#define TextRight 10
#define TextTop 10
#define TextBottom 10

#import <Foundation/Foundation.h>

typedef enum {
    MessageForMe,   //发给别人
    MessageToMe     //收到的
}MessageType;

@interface HYMessage : NSObject

@property (nonatomic, strong) NSString *text;   //内容
@property (nonatomic, strong) NSString *icon;   //头像
@property (nonatomic, strong) NSString *time;   //时间
@property (nonatomic, assign) MessageType type; //类型

@property (nonatomic, strong) NSDictionary *dict;  //存储字典

@end


@interface HYMainMessage : NSObject

@property (nonatomic, assign) CGRect textRect;
@property (nonatomic, assign) CGRect iconRect;
@property (nonatomic, assign) CGRect timeRect;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL  showTime;

@property (nonatomic, strong) HYMessage *message;

@end