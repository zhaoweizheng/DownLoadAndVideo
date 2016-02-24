//
//  ViewController.h
//  XYQSinaTabbar
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController

//添加子控制器
-(void)addChildViewController:(UIViewController *)childVc andTitle:(NSString *)title andImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage;

@end

