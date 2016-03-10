//
//  DownloadEntity.h
//  DownLoadAndVideo
//
//  Created by mistong on 16/3/8.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadEntity : NSObject

//下载地址
@property (nonatomic, strong)NSString *downLoadUrlString;

//添加字段
@property (nonatomic, strong)NSDictionary *extra;

@end
