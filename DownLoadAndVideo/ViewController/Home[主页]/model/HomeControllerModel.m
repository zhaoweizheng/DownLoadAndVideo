//
//  HomeControllerModel.m
//  DownLoadAndVideo
//
//  Created by huanghao on 16/2/26.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "HomeControllerModel.h"

@implementation HomeControllerModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.downLoadString = [dic objectForKey:@"downLoadUrl"];
        self.describe       = [dic objectForKey:@"desc"];
        self.name           = [dic objectForKey:@"name"];
        self.imageName      = [dic objectForKey:@"imgName"];
        
    }
    return self;
}

@end
