//
//  DownloadManager.m
//  DownLoadAndVideo
//
//  Created by mistong on 16/3/8.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "DownloadManager.h"
#define  downLoadTask @"downLoadTask"

@interface DownloadManager ()<DownloadTaskDelegate>

@property (nonatomic, strong) NSMutableDictionary *downloadTasks;
@end

@implementation DownloadManager

+(instancetype)sharedInstance {

    static DownloadManager *downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
    });
    
    return downloadManager;
}

-(instancetype)init {

    self.downloadTasks = [[NSMutableDictionary alloc] init];
    self.downloadArray = [self loadDownLoadTask];
    return [super init];
}

// 获取正在下载的任务数量
-(NSInteger)getDownLoadingTaskCount {
                 //读取完成的下载任务
    return [self loadFinishedTask].count;
}


//发送正在下载任务通知
-(void)postDownLoadingTaskNotification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownLoadingTask object:nil];
    });
}

// 发送删除下载完成任务通知
-(void)postDeleteDownLoadCompleteTaskNotification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownLoadCompleteDeleteTask object:nil];
    });
}

// 发送下载完成任务通知
-(void)postMpDownLoadCompleteTaskNotification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownLoadCompleteTask object:nil];
    });
}


// 获取下载完成的任务数量
-(NSInteger)getFinishedTaskCount{
    return [self loadFinishedTask].count;
}

/**
 *  初始化上次的数据
 */
-(void)initUnFinishedTask{
    for (NSDictionary *dic in [self loadUnFinishedTask]) {
        DownloadTask *downLoadTaskT =  [[DownloadTask alloc ] init];
        NSString *urlKey = [dic objectForKey:@"downloadUrlString"];
        DownloadState downLoadStatus = [self getDownloadState:urlKey];
        downLoadTaskT.sessionModel.downloadState = downLoadStatus;
        downLoadTaskT.sessionModel.urlString = urlKey;
        downLoadTaskT.sessionModel.extra = [dic objectForKey:@"downloadExtra"];
        
        downLoadTaskT.delegate = self;
        [self.downloadTasks setObject:downLoadTaskT forKey:urlKey];
    }
}

-(DownloadState)getDownloadState:(NSString *)url{
    for (NSDictionary *dic in [self loadUnFinishedTask]) {
        NSString *key = [dic objectForKey:@"downloadUrlString"];
        if ([key isEqualToString:url]) {
            return (DownloadState)[[dic objectForKey:@"downloadState"] integerValue];
        }
    }
    return DownloadStateFailed;
}

@end
