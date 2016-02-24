//
//  CustomTabbar.h
//  XYQSinaTabbar
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTabbar;

@protocol CustomTabbarDeleagte <NSObject>

//选中按钮,切换视图,从当前选中的按钮到新的要选中的按钮
- (void)tabBar:(CustomTabbar *)tabBar selectedFrom:(NSInteger)from  to:(NSInteger)to;

@end

@interface CustomTabbar : UIView
@property (strong,nonatomic)UITabBarItem *item;
@property (assign,nonatomic)id<CustomTabbarDeleagte> delegate;
@end
