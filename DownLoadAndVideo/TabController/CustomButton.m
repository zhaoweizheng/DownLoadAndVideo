//
//  CustomButton.m
//  XYQSinaTabbar
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CustomButton.h"

//按钮图片位置的高度系数
#define ImageHeightRadio 0.6
#define tilteGap 10

@implementation CustomButton

-(instancetype)init{
    self = [super init];
    if (self) {
        
        //设置文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
        //设置图片内容模式居中
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

//返回图片的位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * ImageHeightRadio);
}

//返回标题的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, contentRect.size.height * (1 - ImageHeightRadio)+ tilteGap, contentRect.size.width, contentRect.size.height * (1 - ImageHeightRadio));
}

@end
