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

/**
 *  获取任务状态
 *
 *  @param urlString 下载地址
 *
 *  @return 任务状态
 */
-(TaskState)getTaskState:(NSString *)urlString {

    // 下载完成
    if ([[DownloadManager sharedInstance] isCompletion:urlString]) {
        return TaskCompleted;
    }
    // 查询未完成的任务列表
    NSInteger index = [self isExit:urlString];
    
    // 不存在任务
    if (index == -1) {
        return TaskNoExistTask;
    }
    // 任务存在
    else{
        return TaskExistTask;
    }
}

-(NSInteger)isExit:(NSString *)urlString{
    
    for (NSInteger i = 0; i < self.downloadArray.count; i ++) {
        NSDictionary *dic = self.downloadArray[i];
        NSString *url = [dic objectForKey:@"mpDownloadUrlString"];
        if ([url isEqualToString:urlString]) {
            return i;
        }
    }
    return -1;
}


/**
 *  添加下载任务并下载
 *
 *  @param urlString 下载的地址
 */
-(DownloadState)addTaskWithDownLoad:(DownloadEntity *)downloadEntity {
    DownloadTask *downLoadTaskT = [self getDownLoadTask:downloadEntity.downLoadUrlString];
    
    if (downLoadTaskT == nil) {
        downLoadTaskT = [[DownloadTask alloc ] init];
        [self.downloadTasks setObject:downLoadTaskT forKey:downloadEntity.downLoadUrlString];
        DownloadState status =  [downLoadTaskT addTaskWithDownLoad:downloadEntity];
        downLoadTaskT.delegate = self;
        
        // 保存任务状态
        [self saveMPDownLoadTask];
        
        // 发送新任务通知
        [self postDownLoadingTaskNotification];
        
        return status;
    }
    // 任务存在
    return  [downLoadTaskT addTaskWithDownLoad:downloadEntity];
}



-(DownloadTask *)getDownLoadTask:(NSString *)urlkey{
    return  [self.downloadTasks objectForKey:urlkey];
}

//　保存本地任务
-(void)saveMPDownLoadTask{
    NSString *filename = [self filePathWithFileName:downLoadTask];
    for (NSString *string in self.downloadTasks.allKeys) {
        DownloadTask *downLoadTaskT = [self.downloadTasks objectForKey:string];
        NSMutableDictionary *session = [[NSMutableDictionary alloc ] init];
        [session setObject:@(downLoadTaskT.sessionModel.downloadState) forKey:@"downloadState"];
        [session setObject:string                            forKey:@"downloadUrlString"];
        [session setObject:downLoadTaskT.sessionModel.extra forKey:@"downloadExtra"];
        [session setObject:FileFullpath(string)            forKey:@"downLoadPath"];
        
        NSInteger index = [self isExit:string];
        if (index == -1) {
            [self.downloadArray addObject:session];
        }else{
            [self.downloadArray replaceObjectAtIndex:index withObject:session];
        }
    }
    [self.downloadArray writeToFile:filename atomically:NO];
}


-(NSString *)filePathWithFileName:(NSString *)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    return filename;
}

@end
