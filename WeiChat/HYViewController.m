//
//  HYViewController.m
//  WeiChat
//
//  Created by 邱扬 on 14-3-27.
//  Copyright (c) 2014年 邱扬. All rights reserved.
//

#import "HYViewController.h"
#import "HYMainViewController.h"

@interface HYViewController ()

@end

@implementation HYViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)qwe:(id)sender {
    HYMainViewController *mainVC = [[HYMainViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
}
@end
