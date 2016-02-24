//
//  ViewController.m
//  XYQSinaTabbar
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TabBarViewController.h"

#import "HomeViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"

#import "CustomTabbar.h"

@interface TabBarViewController ()<CustomTabbarDeleagte>
@property (strong,nonatomic)CustomTabbar *customTabbar;
@end

@implementation TabBarViewController

//删除系统自动生成的UITabBarButton
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    for (UIView *child in self.tabBar.subviews) {
        
        //NSLog(@"%@",child); //打印结果显示的是：UITabBarButton,它是系统自带私有的,无法直接方法,但是可以从它的父类下手
        //NSLog(@"%@",[child superclass]);//打印的父类是：UIControl
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置自定义的Tabbar
    [self setUpCustomTabbar];

    //创建子控制器
    [self setUpChildcontroller];

}


#pragma mark - 设置自定义的Tabbar
-(void)setUpCustomTabbar{
    
    CustomTabbar *customTabbar = [[CustomTabbar alloc]initWithFrame:self.tabBar.bounds];//设置为tabbar自身的bounds
    customTabbar.delegate = self;
    [self.tabBar addSubview:customTabbar]; //必须添加到tabbar上，这样自定义的customTabbar才能跟着控制器移动
    self.customTabbar = customTabbar;
}


#pragma mark - 设置子控制器
-(void)setUpChildcontroller{
    
    //主页
    HomeViewController *homeVc = [[HomeViewController alloc]init];
    [self addChildViewController:homeVc andTitle:@"主页" andImage:[UIImage imageNamed:@"tabbar_home"] andSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    
    //发现
    DiscoverViewController *discoverVc = [[DiscoverViewController alloc]init];
    [self addChildViewController:discoverVc andTitle:@"发现" andImage:[UIImage imageNamed:@"tabbar_discover"] andSelectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
    
    //消息
    MessageViewController *messageVc = [[MessageViewController alloc]init];
    [self addChildViewController:messageVc andTitle:@"下载" andImage:[UIImage imageNamed:@"tabbar_download"] andSelectedImage:[UIImage imageNamed:@"tabbar_download_on"]];
    
 
    
    //我的
    MineViewController *mineVc = [[MineViewController alloc]init];
    [self addChildViewController:mineVc andTitle:@"我的" andImage:[UIImage imageNamed:@"tabbar_mine"] andSelectedImage:[UIImage imageNamed:@"tabbar_mine_on"]];
}

/**
 *  添加子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
-(void)addChildViewController:(UIViewController *)childVc andTitle:(NSString *)title andImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage{
    
    childVc.title = title; // childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem最终是继承自NSObject的，所以他活该被使用为模型，进行数据的传递
    //将childVc的item当做模型传递到自定义的CustomTabbar,那么自定义的CustomTabbar中就能拿到对应的数据从而来设置自定义的按钮属性
    self.customTabbar.item = childVc.tabBarItem;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];

    [self addChildViewController:nav];
}


#pragma mark - <CustomTabbarDeleagte>
/**
 *  选中按钮,切换控制器
 *
 *  @param tabBar 标签栏
 *  @param from   当前选中的按钮
 *  @param to     新的按钮
 */
-(void)tabBar:(CustomTabbar *)tabBar selectedFrom:(NSInteger)from to:(NSInteger)to{
    
    //跳转到相应的视图控制器. (注意：通过selectIndex参数来设置选中了那个控制器)
    self.selectedIndex = to;
}
@end
