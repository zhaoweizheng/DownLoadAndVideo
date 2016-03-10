//
//  DownloadManager.h
//  DownLoadAndVideo
//
//  Created by mistong on 16/3/8.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"
#import "DownloadEntity.h"

//正在下载任务通知
#define DownLoadingTask @"DownLoadingTask"

//完成下载任务通知
#define DownLoadCompleteTask @"DownLoadCompleteTask"

//删除已下载好的任务通知
#define DownLoadCompleteDeleteTask  @"DownLoadCompleteDeleteTask"

typedef enum {
    TaskNoExistTask = 1,      /** 任务不存在 */
    TaskExistTask   = 2,      /** 任务存在 */
    TaskCompleted   = 3,      /** 下载完成 */
}TaskState;

@interface DownloadManager : NSObject

//所有下载的数据状态
@property (nonatomic, strong) NSMutableArray *downloadArray;

/**
 *  单例
 *  @return 返回单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  获取任务状态
 *
 *  @param urlString 下载地址
 *
 *  @return 任务状态
 */
- (TaskState)getTaskState:(NSString *)urlString;

/**
 *  添加下载任务并下载
 *
 *  @param downloadEntity <#downloadEntity description#>
 *
 *  @return 状态
 */
- (DownloadState)addTaskWithDownLoad:(DownloadEntity *)downloadEntity;



-(void)downLoad:(NSString *)url progressBlock:(DownloadProgressBlock)progressBlock completeBlock:(DownloadCompleteBlock)completeBlock;

-(void)initUnFinishedTask;

// 获取正在下载的任务数量
-(NSInteger)getDownLoadingTaskCount;

// 获取下载完成的任务数量
-(NSInteger)getFinishedTaskCount;

/**
 *  查询该资源的下载进度值
 */
- (CGFloat)progress:(NSString *)url;

/**
 *  开始下载
 */
- (void)start:(NSString *)url;

/**
 *  暂停下载
 */
- (void)pause:(NSString *)url;

/**
 *  删除该资源
 *
 *  @param url 下载地址
 */
- (void)deleteFile:(NSString *)url;

/**
 *  删除所有的任务
 */
-(void)deleAllTask;

/**
 *  开始所有任务
 */
-(void)startAllTask;

/**
 *  暂停所有任务
 */
-(void)pauseAllTask;


/**
 *  判断该文件是否下载完成
 */
- (BOOL)isCompletion:(NSString *)url;

/**
 *  获取文件的下载主目录
 *
 *  @return
 */
-(NSString *)getDownLoadPath;

/**
 *  读取所有的任务
 *
 *  @return
 */
-(NSMutableArray *)loadDownLoadTask;

/**
 *  读取未完成的下载任务
 *
 *  @return
 */
-(NSArray *)loadUnFinishedTask;

/**
 *  读取完成的下载任务
 *
 *  @return
 */
-(NSArray *)loadFinishedTask;

@end
