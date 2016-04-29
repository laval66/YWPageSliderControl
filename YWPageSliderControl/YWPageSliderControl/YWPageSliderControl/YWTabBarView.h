//
//  YWTabBarView.h
//  YWPageSliderControl
//
//  Created by LYW on 16/3/28.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YWTabBarStyle) {
    YWTabBarStyleUnderline     = 0,     //下划线风格
};  //可自行定制其他光标风格

@protocol PageSliderDelegate <NSObject>

@optional

- (void)setContentAtIndex:(NSInteger)index;

@end

@interface YWTabBarView : UIView

@property (nonatomic, weak) id <PageSliderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray style:(YWTabBarStyle)style;

@property (nonatomic, strong, readonly) NSArray *titles;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, strong) UIScrollView *contentScrollView;

- (void)selectAtIndex:(NSInteger)index animation:(BOOL)animation;

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation;

@end


@interface TabBarMenuStyleModel : NSObject

@property (nonatomic, assign) CGFloat menuHeight;
@property (nonatomic, strong) UIColor *menuBackgroundColor;
@property (nonatomic, assign) CGFloat buttonSpacing;
@property (nonatomic, strong) UIColor *menuNormalColor;
@property (nonatomic, strong) UIColor *menuSelectedColor;
@property (nonatomic, strong) UIView *bottomView;

@end
