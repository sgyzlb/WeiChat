//
//  HYMainViewController.m
//  WeiChat
//
//  Created by 邱扬 on 14-3-24.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#import "HYMainViewController.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>    //pf_inet

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
    
#warning //演示效果   初始化信息
    //NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"temMessage" ofType:@"plist"]];
    NSArray *array = [NSArray arrayWithContentsOfFile: @"/Users/peter/Desktop/WeiChat/temMessage.plist"];
    
    _allMainMessage = [NSMutableArray array];
    _allMainMessageArray = [[NSMutableArray alloc ] init];
    NSString *previousTime = nil;
    for (NSDictionary *dict in array) {
        
        HYMainMessage *messageFrame = [[HYMainMessage alloc] init];
        HYMessage *message = [[HYMessage alloc] init];
        message.dict = dict;
        
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        messageFrame.message = message;
        
        previousTime = message.time;
        
        [_allMainMessage addObject:messageFrame];
        [_allMainMessageArray addObject:dict];
        
        
    }
    
    //启用链接
    [self startConnect];
    
    _messageText.delegate = self;
    //设置textField输入起始位置
    _messageText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _messageText.leftViewMode = UITextFieldViewModeAlways;
    
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //滚动table
    if (_allMainMessage.count > 0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:_allMainMessage.count - 1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//视图即将被驳回时调用
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //获取路径对象
    //获取完整路径
    NSString *plistPath = @"/Users/peter/Desktop/WeiChat/temMessage.plist";
    //写入文件
    [_allMainMessageArray writeToFile:plistPath atomically:YES];
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
    
    //定义第一个插件的属性
    NSMutableDictionary *plugin1 = [[NSMutableDictionary alloc]init];
    [plugin1 setObject:tempText forKey:@"text"];
    [plugin1 setObject:tempTime forKey:@"time"];
    [plugin1 setObject:@"head1" forKey:@"icon"];
    [plugin1 setObject:[NSNumber numberWithInt:0] forKey:@"type"];
    //设置属性值
    [_allMainMessageArray addObject:plugin1];
    
    
    [self sendMessage:tempText];
    
    return YES;
}

- (void)addMessage:(NSString *)text time:(NSString *)time {
    HYMainMessage *addMainMessage = [[HYMainMessage alloc] init];
    HYMessage *addMessage = [[HYMessage alloc] init];
    addMessage.text = text;
    addMessage.time = time;
    addMessage.type = MessageForMe;
    addMessage.icon = @"head1";
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

#pragma mark 创建链接
- (void)CreateConnect{
    CFSocketContext sockContext = {0,   //结构体版本，必须0
        (__bridge void *)(self),
        NULL,   //一个定义在上面指针中的retain的回调，可以为null
        NULL,
        NULL};
    
    _socket = CFSocketCreate(kCFAllocatorDefault,      //为新对象分配内存，可以为nil
                             PF_INET,                  //协议簇，如果为0或者负数，默认为PF_INET
                             SOCK_STREAM,              //套接字类型，如果协议簇为PF_INET 塌毁默认为sock_stream
                             IPPROTO_TCP,              //套接字协议，如果协议簇为PF_INET切协议为0或者负数，默认为IPPROTO_TCP
                             kCFSocketConnectCallBack, //触发回调函数的socket消息类型，具体callback
                             hyTcpClientCallBack,      //上 main情况下触发回调函数
                             &sockContext);            //一个持有CFSocket结构信息的对象，可以为nil
    if (_socket != NULL) {
        struct sockaddr_in addr4;   //ipv4
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(8888);
        addr4.sin_addr.s_addr = inet_addr("127.0.0.1");  //字符串地址转换为机器可以识别的网络地址
        
        //把sockaddr——in结构体中的地址转化为Data
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr4, sizeof(addr4));
        CFSocketConnectToAddress(_socket, //连接的socket
                                 address, //cfdataref类型的包含上面socket的远程地址的对象
                                 1);     //链接超时时间，为负数就不会尝试链接，而是把链接放在后台进行。如果socket消息类行为：kCFSocketConnectCallBack，将会在连接成功或失败的时候在后台触发回调函数
        CFRunLoopRef cRunRef = CFRunLoopGetCurrent();  //获取当前县城的循环
        
        //创建一个循环，没有真正的加入到循环中，需要调用CFRunLoopAddSource
        CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
        
        CFRunLoopAddSource(cRunRef,                 //运行循环
                           sourceRef,               //增加的运行循环源，他会被retain一次
                           kCFRunLoopCommonModes);  //增加的运行循环源的模式
        CFRelease(sourceRef);
    }
    
}

// socket回调函数，同客户端
static void hyTcpClientCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    HYMainViewController *hyMainVCClient = (__bridge HYMainViewController *)info;
    if (data != NULL) {
        NSLog(@"连接失败");
    } else {
        NSLog(@"连接成功");
        
        //读取接收的数据
        [hyMainVCClient StartReadThread];
    }
}

-(void)StartReadThread {
    NSThread *initThread = [[NSThread alloc] initWithTarget:self selector:@selector(InitThreadFunc:) object:self];
    [initThread start];
}

-(void)InitThreadFunc:(id)sender {
    while (1) {
        [self readStream];
    }
}

//读取数据
- (void)readStream {
    char buffer[1024];
    @autoreleasepool {
        recv(CFSocketGetNative(_socket), buffer, sizeof(buffer), 0);
        NSString *str = [NSString stringWithUTF8String:buffer];
        [self performSelectorOnMainThread:@selector(addMsg:) withObject:str waitUntilDone:NO];
    }
}

- (void)addMsg:(id)sender {
    NSString *text = sender;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:text, @"text", @"10:00", @"time", @"head2", @"icon", @"1", @"type", nil];
    HYMainMessage *messageFrame = [[HYMainMessage alloc] init];
    HYMessage *message = [[HYMessage alloc] init];
    message.dict = dict;
    messageFrame.message = message;
    [_allMainMessage addObject:messageFrame];
    [_allMainMessageArray addObject:dict];
    [self.mainTableView reloadData];
    //滚动table
    if (_allMainMessage.count > 0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:_allMainMessage.count - 1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}

//发送消息
- (void)sendMessage:(NSString *)str {
    const char* data = [str UTF8String];
    uint8_t *unit8 = (uint8_t*)data;
    //const char* data = [str cStringUsingEncoding:NSASCIIStringEncoding];
    send(CFSocketGetNative(_socket), unit8, strlen(data) + 1, 0);
}

//启动链接
- (void)startConnect {
    [self CreateConnect];
}

@end
