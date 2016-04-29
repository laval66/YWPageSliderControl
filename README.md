# YWPageSliderControl
上方是可滚动的菜单栏，下方是可滚动的内容视图。可通过点击菜单栏按钮选择子视图；也可直接滚动子视图选择。子视图采用预加载模式，最大程度节省内存。

生成菜单栏+子视图内容的总View。

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray style:(YWTabBarStyle)style; //初始化方法


//滚动视图的委托和添加内容视图的委托设置。

YWTabBarView.contentScrollView.delegate = self;

YWTabBarView.delegate = self;

//初始化内容视图，添加第一页后菜单默认显示为选中第一页。

[self addContentAciton:0];

//若要默认选择其他页，重新布局视图，然后执行选择页面的方法。

[YWTabBarView layoutIfNeeded];

[YWTabBarView selectAtIndex:index animation:NO];


TabBarMenuStyleModel中提供了几种菜单栏可修改的属性。

可在setupStyleModel中手动定制菜单栏。
