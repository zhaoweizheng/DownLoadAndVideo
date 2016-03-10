//
//  HomeViewCell.h
//  DownLoadAndVideo
//
//  Created by mistong on 16/2/24.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeControllerModel.h"
@interface HomeViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *videoImage;   //视频图形
@property (nonatomic, strong) UILabel *videoName;        //视频名字
@property (nonatomic, strong) UILabel *videoIntroduction;//视频介绍
@property (nonatomic, strong) UIButton *videoDownload;   //视频下载按钮
@property (nonatomic, strong) UILabel *grayLabel;        //视频介绍

- (void)layoutCellList:(HomeControllerModel *)model;
@end
