//
//  ViewController.m
//  YWPageSliderControl
//
//  Created by LYW on 16/3/28.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import "ViewController.h"
#import "YWTabBarView.h"
#import "ContentViewController.h"

#define ImageNameArray @[@"JudyHopps", @"NickWilde", @"CheifBogo", @"Flash", @"Yax"]

@interface ViewController () <PageSliderDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) YWTabBarView *menuView;

@property (strong, nonatomic) NSMutableDictionary * contentQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.menuView = [[YWTabBarView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) titleArray:ImageNameArray style:0];
        [self.view addSubview:self.menuView];
        self.menuView.contentScrollView.delegate = self;
        
        //内容视图的委托，若不需要可不用实现
        self.menuView.delegate = self;
        //添加第一页
        [self addContentAciton:0];
        
        [self.menuView layoutIfNeeded];
        //初始选择页面。此处应禁止滚动动画
        //[self.menuView selectAtIndex:3 animation:NO];
    });
}

#pragma - mark  PageSliderDelegate
- (void)setContentAtIndex:(NSInteger)index
{
    [self addContentAciton:index];
}

#pragma - mark  ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger pageIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5); //过半取整
    [self.menuView moveToIndex:pageIndex animation:YES];
}

#pragma - mark  添加子视图
- (void)addContentAciton:(NSInteger)index
{
    if (!self.contentQueue) {
        self.contentQueue = [[NSMutableDictionary alloc] init];
    }
    //页面数大于5时，移除其他缓存页面
    if (self.contentQueue.allKeys.count > 5) {
        [self removeContentVC:index];
    }
    
    if (![self.contentQueue objectForKey:@(index)]) {
        [self addVCAtIndex:index];
    }
    //预加载上一页和下一页
    if (index > 0) {
        if (![self.contentQueue objectForKey:@(index - 1)]) {
            [self addVCAtIndex:index - 1];
        }
    }
    if (index < self.menuView.titles.count - 1) {
        if (![self.contentQueue objectForKey:@(index + 1)]) {
            [self addVCAtIndex:index + 1];
        }
    }
}

- (void)addVCAtIndex:(NSInteger)index
{
    ContentViewController * contentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentViewController"];
    [self addChildViewController:contentVC];
    contentVC.contentTag = index;
    contentVC.view.frame = CGRectMake(index * self.view.bounds.size.width, 10, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.menuView.contentScrollView addSubview:contentVC.view];
    [self.contentQueue setObject:contentVC forKey:@(index)];
}

- (void)removeContentVC:(NSInteger)index
{
    [self.contentQueue enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key integerValue] != index) {
            UIViewController *contentVC = (UIViewController *)obj;
            [contentVC willMoveToParentViewController:nil];
            [contentVC removeFromParentViewController];
            [contentVC.view removeFromSuperview];
            [contentVC didMoveToParentViewController:nil];
        }
    }];
    [self.contentQueue removeAllObjects];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
