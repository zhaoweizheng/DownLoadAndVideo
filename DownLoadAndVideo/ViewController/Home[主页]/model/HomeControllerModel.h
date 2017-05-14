//
//  HomeControllerModel.h
//  DownLoadAndVideo
//
//  Created by huanghao on 16/2/26.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeControllerModel : NSObject

@property (nonatomic, copy) NSString *downLoadString;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
