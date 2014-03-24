//
//  HYMainViewController.m
//  WeiChat
//
//  Created by 邱扬 on 14-3-24.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#import "HYMainViewController.h"

@interface HYMainViewController ()

@end

@implementation HYMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //table背景
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.allowsSelection = NO;
    _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    
    _messageText.delegate = self;
    //设置textField输入起始位置
    _messageText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _messageText.leftViewMode = UITextFieldViewModeAlways;
    
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _messageText.text = nil;
    return YES;
}

#pragma mark - 代理方法

//当你下滑后  手指离开view的那一刻
//收回键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)speakMessage:(id)sender {
    if (_messageText.hidden == YES) {
        _messageText.hidden = NO;
        _speakBtn.hidden = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"voice_normal"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"voice_height"] forState:UIControlStateHighlighted];
        //唤出键盘
        [_messageText becomeFirstResponder];
    } else {
        _messageText.hidden = YES;
        _speakBtn.hidden = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"keyboard_normal"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"keyboard_height"] forState:UIControlStateHighlighted];
        //收回键盘
        [_messageText resignFirstResponder];
    }
}


#pragma mark -- tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
