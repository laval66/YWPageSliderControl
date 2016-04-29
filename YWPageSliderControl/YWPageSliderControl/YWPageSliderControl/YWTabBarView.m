//
//  YWTabBarView.m
//  YWPageSliderControl
//
//  Created by LYW on 16/3/28.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import "YWTabBarView.h"

@interface YWTabBarView()

@property (nonatomic, assign) YWTabBarStyle style;
@property (nonatomic, strong) TabBarMenuStyleModel *styleModel;

@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *cursorView;

@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation YWTabBarView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titles style:(YWTabBarStyle)style;
{
    if (self = [super init]) {
        self.frame = frame;
        _titles = titles;
        _style = style;
        [self setupStyleModel];
        [self setupMenu];
        [self setupContent];
    }
    return self;
}

- (void)setupStyleModel
{
    self.styleModel = [TabBarMenuStyleModel new];
    if (_style == YWTabBarStyleUnderline) {
        _styleModel.menuHeight = 44;
        _styleModel.buttonSpacing = 10;
        _styleModel.menuNormalColor = [UIColor colorWithRed:25/255.0f green:140/255.0f blue:56/255.0f alpha:0.5];
        _styleModel.menuSelectedColor = [UIColor colorWithRed:25/255.0f green:140/255.0f blue:56/255.0f alpha:1.0];
    }
}

- (void)setupMenu
{
    self.menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.styleModel.menuHeight)];
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.menuScrollView];
    
    //设置按钮
    self.buttons = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i ++) {
        UIButton * button = [UIButton new];
        button.tag = i;
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        //当前所选按钮设置为选择色
        [button setTitleColor:self.currentIndex == i ? self.styleModel.menuSelectedColor  : self.styleModel.menuNormalColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = [UIColor clearColor];
        [button sizeToFit];
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuScrollView addSubview:button];
        [self.buttons addObject:button];
    }
    
    //设置光标视图
    [self setupCursor];
}

- (void)setupContent
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.styleModel.menuHeight, self.bounds.size.width, self.bounds.size.height - self.styleModel.menuHeight)];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    [self.contentScrollView setContentSize:CGSizeMake(self.bounds.size.width * self.buttons.count, self.bounds.size.height - self.styleModel.menuHeight)];
    [self addSubview:self.contentScrollView];
}

-(void)setupCursor
{
    self.cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.menuScrollView.frame.size.width, 0)];
    //插入到最底层防止遮挡按钮
    [self.menuScrollView insertSubview:self.cursorView atIndex:0];
    
    //根据风格设置光标
    if (self.style == YWTabBarStyleUnderline) {
        UIView *underLine = [[UIView alloc] init];
        underLine.backgroundColor = self.styleModel.menuSelectedColor;
        [self.cursorView addSubview:underLine];
        //添加约束
        underLine.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[underLine]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(underLine)];
        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[underLine(2)]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(underLine)];
        [self.cursorView addConstraints:hConstraints];
        [self.cursorView addConstraints:vConstraints];
    }
}

#pragma - mark Relayout Buttons After AddSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemTotalWidth = 0;
    CGFloat itemSingleWidth = 0;
    
    for (UIButton * button in self.buttons) {
        itemTotalWidth += button.bounds.size.width;
        if (itemSingleWidth < button.bounds.size.width) {
            itemSingleWidth = button.bounds.size.width;
        }
    }
    
    CGFloat totalWidth = itemTotalWidth + (self.buttons.count + 1) * 2 * self.styleModel.buttonSpacing;
    
    //总长度（含间距）小于屏幕宽，重绘按钮，间距为0
    if (totalWidth <= self.menuScrollView.bounds.size.width) {
        self.styleModel.buttonSpacing = 0;
        CGFloat averageWidth = self.menuScrollView.bounds.size.width / self.buttons.count;
        for (int i = 0; i < self.buttons.count; i ++) {
            UIButton * button = self.buttons[i];
            button.frame = CGRectMake(averageWidth * i, 0, averageWidth, self.menuScrollView.bounds.size.height);
        }
        [self.menuScrollView setContentSize:CGSizeMake(self.menuScrollView.bounds.size.width, self.styleModel.menuHeight)];
        
        if (!self.isAnimation) {
            //若无需滚动，则选中标识view绘制不含按钮间隔
            UIButton * selectButton = [self.buttons objectAtIndex:self.currentIndex];
            self.cursorView.frame = CGRectMake(selectButton.center.x - selectButton.bounds.size.width / 2, 0, selectButton.bounds.size.width, self.styleModel.menuHeight);
        }
    }
    else {
        self.styleModel.buttonSpacing = 10;
        CGFloat left = 2 * self.styleModel.buttonSpacing;
        for (UIButton *button in self.buttons) {
            button.frame = CGRectMake(left, 0, button.bounds.size.width, self.menuScrollView.bounds.size.height);
            left += button.bounds.size.width + 2 * self.styleModel.buttonSpacing;
        }
        [self.menuScrollView setContentSize:CGSizeMake(totalWidth, self.styleModel.menuHeight)];
        
        if (!self.isAnimation) {
            UIButton * selectButton = [self.buttons objectAtIndex:self.currentIndex];
            self.cursorView.frame = CGRectMake(self.styleModel.buttonSpacing, 0, selectButton.bounds.size.width + self.styleModel.buttonSpacing * 2, self.styleModel.menuHeight);
        }
    }
}

- (void)buttonEvent:(UIButton *)sender {
    NSInteger index = sender.tag;
    [self selectAtIndex:index animation:YES];
}

- (void)selectAtIndex:(NSInteger)index animation:(BOOL)animation
{
    [self moveToIndex:index animation:animation];
    [self.contentScrollView setContentOffset:CGPointMake(index * self.contentScrollView.bounds.size.width, 0) animated:NO];//点击按钮切换视图的动画可选择是否需要
}

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation {
    if (index == self.currentIndex || self.isAnimation) {
        return;
    }
    
    self.isAnimation = YES;
    
    //以下委托用于动态添加子内容视图
    if ([self.delegate respondsToSelector:@selector(setContentAtIndex:)]) {
        [self.delegate setContentAtIndex:index];
    }
    
    //上一个按钮的恢复
    UIButton *lastButton = [self.buttons objectAtIndex:self.currentIndex];
    [lastButton setTitleColor:self.styleModel.menuNormalColor forState:UIControlStateNormal];
    
    //点击按钮状态变化
    UIButton *clickButton = [self.buttons objectAtIndex:index];
    [clickButton setTitleColor:self.styleModel.menuSelectedColor forState:UIControlStateNormal];
    
    //动画完成前，设置上一个按钮后设置新的index
    _currentIndex = index;
    
    //光标移动动画
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.cursorView.frame = CGRectMake(clickButton.center.x - (clickButton.bounds.size.width / 2 + self.styleModel.buttonSpacing), 0, clickButton.bounds.size.width + 2 * self.styleModel.buttonSpacing, self.styleModel.menuHeight);
        } completion:^(BOOL finished) {
            self.isAnimation = NO;
        }];
    }
    else {
        self.isAnimation = NO;
        self.cursorView.frame = CGRectMake(clickButton.center.x - (clickButton.bounds.size.width / 2 + self.styleModel.buttonSpacing), 0, clickButton.bounds.size.width + 2 * self.styleModel.buttonSpacing, self.styleModel.menuHeight);
    }
    
    //当选中按钮的位置>中心点时，自动居中
    if (self.menuScrollView.contentSize.width > self.menuScrollView.bounds.size.width) {
        [self makeButtonCenter:clickButton animation:animation];
    }
}

- (void)makeButtonCenter:(UIButton *)clickButton animation:(BOOL)animation
{
    if (clickButton.center.x + self.menuScrollView.bounds.size.width / 2 > self.menuScrollView.contentSize.width) {
        [self.menuScrollView setContentOffset:CGPointMake(self.menuScrollView.contentSize.width - self.bounds.size.width,self.menuScrollView.contentOffset.y)animated:YES];
    }
    else if (clickButton.center.x - self.bounds.size.width / 2 < 0) {
        [self.menuScrollView setContentOffset:CGPointMake(0, self.menuScrollView.contentOffset.y) animated:animation];
    } else {
        [self.menuScrollView setContentOffset:CGPointMake(clickButton.center.x - self.menuScrollView.bounds.size.width / 2, self.menuScrollView.contentOffset.y) animated:animation];
    }
}

@end


@implementation TabBarMenuStyleModel

@end
