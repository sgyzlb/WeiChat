//
//  HYMainViewController.m
//  WeiChat
//
//  Created by 邱扬 on 14-3-24.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#warning 需要添加接收消息recv

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
#warning 测试用
    _yn = YES;
    
    // Do any additional setup after loading the view from its nib.
    //table背景
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.allowsSelection = NO;
    _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    
#warning //演示效果   初始化信息
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"temMessage" ofType:@"plist"]];
    
    _allMainMessage = [NSMutableArray array];
    NSString *previousTime = nil;
    for (NSDictionary *dict in array) {
        
        HYMainMessage *messageFrame = [[HYMainMessage alloc] init];
        HYMessage *message = [[HYMessage alloc] init];
        message.dict = dict;
        
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        messageFrame.message = message;
        
        previousTime = message.time;
        
        [_allMainMessage addObject:messageFrame];
    }
    
    
    
    _messageText.delegate = self;
    //设置textField输入起始位置
    _messageText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _messageText.leftViewMode = UITextFieldViewModeAlways;
    
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        self.mainTableView.frame = CGRectMake(0, 0, 320, 520 - rect.size.height);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        self.mainTableView.frame = CGRectMake(0, 0, 320, 520);
    }];
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //获取数据
    NSString *tempText = _messageText.text;
    if ([tempText isEqualToString:@""]) {
        return NO;
    }
    //获取当前时间
    NSDateFormatter *tempFormatTime = [[NSDateFormatter alloc] init];
    tempFormatTime.dateFormat = @"MM-dd";
    NSString *tempTime = [tempFormatTime stringFromDate:[NSDate date]];
    //增加数据
    [self addMessage:tempText time:tempTime];
    //刷新table
    [self.mainTableView reloadData];
    //滚动table
    NSIndexPath *index = [NSIndexPath indexPathForRow:_allMainMessage.count - 1 inSection:0];
    [self.mainTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //将text清空
    _messageText.text = nil;
    
    
#warning  需要添加网络send  发送消息
    
    return YES;
}

- (void)addMessage:(NSString *)text time:(NSString *)time {
    HYMainMessage *addMainMessage = [[HYMainMessage alloc] init];
    HYMessage *addMessage = [[HYMessage alloc] init];
    addMessage.text = text;
    addMessage.time = time;
#warning 测试用
    if (_yn) {
        addMessage.type = MessageForMe;
        addMessage.icon = @"head1";
        _yn = NO;
    } else {
        addMessage.type = MessageToMe;
        addMessage.icon = @"head2";
        _yn = YES;
    }
    addMainMessage.message = addMessage;
    
    [_allMainMessage addObject:addMainMessage];
}

#pragma mark - 代理方法  //当你下滑后  手指离开view的那一刻 //收回键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark //按住说话
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
    
    
    
#warning 这里添加语音接口  按住可以说话
    
}

- (IBAction)imgMessage:(id)sender {
#warning 这里添加弹出图像键盘
}

- (IBAction)addMessage:(id)sender {
#warning 添加附加键盘：照片，照相 ，地点等。
}


#pragma mark -- tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allMainMessage.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMainMessage[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *chatCellIdentifier = @"chatcellidentifier";
    HYMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCellIdentifier];
    
    if (cell == nil) {
        cell = [[HYMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCellIdentifier];
    }
    
    cell.mainMessage = _allMainMessage[indexPath.row];
    
    return cell;
}

@end
