//
//  ContentViewController.m
//  YWPageSliderControl
//
//  Created by LYW on 16/3/29.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import "ContentViewController.h"

#define ImageNameArray @[@"JudyHopps", @"NickWilde", @"ChiefBogo", @"Flash", @"Yax"]

@interface ContentViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityView startAnimating];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.activityView stopAnimating];
        self.imageView.image = [UIImage imageNamed:ImageNameArray[self.contentTag]];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
