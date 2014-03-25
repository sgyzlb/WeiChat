//
//  HYMainViewController.h
//  WeiChat
//
//  Created by 邱扬 on 14-3-24.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMessageTableViewCell.h"

@interface HYMainViewController : UIViewController<UITableViewDelegate, UITextFieldDelegate> {
    BOOL _yn;
}

@property (nonatomic, strong) NSMutableArray *allMainMessage;

@property (weak, nonatomic) IBOutlet UIButton *speakBtn;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
- (IBAction)speakMessage:(id)sender;
- (IBAction)imgMessage:(id)sender;
- (IBAction)addMessage:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
