//
//  CustomTabbar.m
//  XYQSinaTabbar
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CustomTabbar.h"
#import "CustomButton.h"

static NSInteger startTag = 0; //初始按钮的tag值

@interface CustomTabbar()
@property (strong,nonatomic)UIButton *pluButton;
@property (strong,nonatomic)UIButton *selectedBtn;
@end

@implementation CustomTabbar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置tabbar背景颜色
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]];
        /*
        //添加一个加号按钮
        UIButton *pluButton = [[UIButton alloc]init];
        [pluButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [pluButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [pluButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [pluButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [pluButton addTarget:self action:@selector(pluButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.pluButton = pluButton;
         */
    }
    return self;
}

//重写item的setter方法，接受新的item
-(void)setItem:(UITabBarItem *)item{
    
    _item = item;
    
    //添加按钮,设置tag标记
    CustomButton *button = [[CustomButton alloc]init];
    button.tag = startTag++;
    
    //设置按钮属性和事件
    [button setTitle:item.title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [button setImage:item.image forState:UIControlStateNormal];
    [button setImage:item.selectedImage forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickBtnItem:) forControlEvents:UIControlEventTouchDown];
    
    //添加到自定义的tabbar上
    [self addSubview:button];
    
    
    /*
    //将加号按钮插入到第二个位置上
    if (self.subviews.count == 2 ) {
        
        [self insertSubview:self.pluButton atIndex:2];
    }
    */
    
    //默认第一个按钮是选中的
    if (button.tag == 0) {
        
        [self clickBtnItem:button];
    }
}

/**
 *  自定义TabBar的按钮点击事件
 */
- (void)clickBtnItem:(UIButton *) button {
    
    //1.通过代理传递按钮tag
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
        
        [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:button.tag];
    }
    
    //2.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    
    //3.再将当前按钮设置为选中
    button.selected = YES;
    
    //4.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;
}

/**
 *  自定义的加号按钮事件,此事件用来实现发布控制器模态的开启和关闭
 */
-(void)pluButtonClicked:(UIButton *)pluButton{
    
    NSLog(@"%s",__func__);
}


//布局子视图
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置frame属性
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonH = self.frame.size.height;
    
    //获取到视图中的所有子视图
    for (int index = 0; index < self.subviews.count; index++) {
        CGFloat buttonX = buttonW * index;
        CustomButton *btn = self.subviews[index];
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}
@end
