//
//  HomeViewCell.m
//  DownLoadAndVideo
//
//  Created by mistong on 16/2/24.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "HomeViewCell.h"

@implementation HomeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self custumSomeView];
        
    }
    return self;
}

- (void)custumSomeView{
    
    self.videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, SCREEN_WIDTH/2.0)];
    [self addSubview:self.videoImage];
    
    
    self.videoName = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.videoImage.frame) + 10, SCREEN_WIDTH - 20, 15)];
    self.videoName.font = KFont(15);
    self.videoName.textColor = [UIColor blackColor];
    self.videoName.textAlignment = NSTextAlignmentLeft;
    self.videoName.text = @"小黄人大眼眶";
    [self addSubview:self.videoName];
    
    self.videoIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.videoName.frame) + 5, SCREEN_WIDTH - 20 - 50, 30)];
    self.videoIntroduction.font = KFont(12);
    self.videoIntroduction.textColor = [UIColor grayColor];
    self.videoIntroduction.textAlignment = NSTextAlignmentLeft;
    self.videoIntroduction.numberOfLines = 0;
    self.videoIntroduction.text = @"<<小黄人大眼眶>>是一部2015年的美国喜剧动画电影.该影片是由黄浩和他的同事";
    [self addSubview:self.videoIntroduction];
    
    self.videoDownload = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoDownload.frame = CGRectMake(SCREEN_WIDTH - 50, CGRectGetMaxY(self.videoImage.frame) + 20, 30, 30);
    [self addSubview:self.videoDownload];
    
    self.grayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.videoIntroduction.frame) + 10, SCREEN_WIDTH, 10)];
    self.grayLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:self.grayLabel];
}

- (void)layoutCellList:(HomeControllerModel *)model{
    
    self.videoImage.image = [UIImage imageNamed:model.imageName];
    self.videoName.text = model.name;
    self.videoIntroduction.text = model.describe;
    [self.videoDownload setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal
     ];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
