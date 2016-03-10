//
//  DownloadTask.m
//  DownLoadAndVideo
//
//  Created by mistong on 16/3/8.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "DownloadTask.h"

@interface DownloadTask()<NSURLSessionDelegate>

@end


@implementation DownloadTask

-(instancetype)init {
    [self configureDownLoadSession];
    self.sessionModel = [[SessionModel alloc] init];
    return [super init];
}

/**
 *  配置下载回话层
 */
- (void)configureDownLoadSession {
    /**
     + (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(nullable id <NSURLSessionDelegate>)delegate delegateQueue:(nullable NSOperationQueue *)queue;
     */
    self.sesssion = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
}

/**
 *  添加下载任务并下载
 *
 *  @param downloadEntity 类
 *
 *  @return 状态
 */
-(DownloadState)addTaskWithDownLoad:(DownloadEntity *)downloadEntity {
    
    //下载
    if ([self continueDownLoad:downloadEntity.downLoadUrlString]) {
        [self downLoad:downloadEntity.downLoadUrlString progressBlock:nil completeBlock:nil downloadState:DownloadStateRunning];
    }
    self.sessionModel.extra = downloadEntity.extra;
    
    return self.sessionModel.downloadState;
}

//下载状态
- (BOOL)continueDownLoad:(NSString *)url{
    
    BOOL continueDownLoad = YES;
    
    //下载完成
    if ([self isCompletion:url]) {
        self.sessionModel.downloadState = DownloadStateCompleted;
        continueDownLoad = NO;
    }
    //    else if (self.mpSessionModel.mpDownloadState == MPDownloadStateSuspended){
    //
    //        continueDownLoad = NO;
    //    }else if (self.mpSessionModel.mpDownloadState == MPDownloadStateRunning){
    //
    //        continueDownLoad = YES;
    //    }
    //    else if (self.mpSessionModel.mpDownloadState == MPDownloadStateFailed){
    //
    //        continueDownLoad = NO;
    //    }
    return continueDownLoad;
}

/**
 *  判断该文件是否下载完成
 *
 *  @param url 下载地址
 *
 *  @return 返回yes或者no
 */
- (BOOL)isCompletion:(NSString *)url {
    
    if ([self fileTotalLength:url] && DownloadLength(url) == [self fileTotalLength:url]) {
        
        return YES;
    }
    
    return NO;
}


/**
 *  获取该资源总大小
 */

- (NSInteger)fileTotalLength:(NSString *)url {
    
    return [[NSDictionary dictionaryWithContentsOfFile:TotalLengthFullpath][FileName(url)] integerValue];
}

/**
 *  查询该资源的下载进度值
 */
- (CGFloat)progress:(NSString *)url
{
    return [self fileTotalLength:url] == 0 ? 0.0 : 1.0 * DownloadLength(url) /  [self fileTotalLength:url];
}


-(void)downLoad:(NSString *)url progressBlock:(DownloadProgressBlock)progressBlock completeBlock:(DownloadCompleteBlock)completeBlock downloadState:(DownloadState)downloadState {

    self.downloadProgressBlock = progressBlock;
    self.downloadCompleteBlock = completeBlock;
    
    //不能继续下载
    if (![self continueDownLoad:url]) {
        
        return;
    }
    
    //创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:FileFullpath(url) append:YES];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", DownloadLength(url)];

    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 创建一个Data任务
    if (self.downLoadTask == nil) {
        self.downLoadTask = [self.sesssion dataTaskWithRequest:request];
        self.sessionModel.urlString = url;
        self.sessionModel.stream    = stream;
        self.sessionModel.downloadPath = FileFullpath(url);
        
        //开始下载
        if (downloadState == DownloadStateRunning) {
            [self start:url];
            
        //暂停下载
        } else if (downloadState == DownloadStateSuspended){
        
        }
    }
    
}


//开始下载
-(void)start:(NSString *)url {
    
    if (self.downLoadTask) {
        self.sessionModel.downloadState = DownloadStateRunning;
        
        [self.downLoadTask resume];//继续
        
        //下载完成
        if (self.downloadCompleteBlock) {
            self.downloadCompleteBlock(self.sessionModel.downloadState, self.sessionModel.urlString);
        }
    }

}


//暂停下载
-(void)pause:(NSString *)url {

    if (self.downLoadTask) {
        self.sessionModel.downloadState = DownloadStateSuspended;
        if (self.downLoadTask.state == NSURLSessionTaskStateRunning) {
            [self.downLoadTask suspend];//暂停
        }
        
        if (self.downloadCompleteBlock) {
            self.downloadCompleteBlock(self.sessionModel.downloadState, self.sessionModel.urlString);
        }
    }
}


//创建缓存目录文件
- (void)createCacheDirectory {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:CachesDirectory]) {
        [fileManager createDirectoryAtPath:CachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

#pragma mark NSURLSessionDataDelegate

/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //打开流
    [self.sessionModel.stream open];
    //获得服务器这次请求, 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + DownloadLength(self.sessionModel.urlString);
    self.sessionModel.totalLength = totalLength;
    
    
    //存储总长度
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:TotalLengthFullpath];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
        
        dict[FileName(self.sessionModel.urlString)] = @(totalLength);
        [dict writeToFile:TotalLengthFullpath atomically:YES];
    }
    
    //接收这个请求, 允许接收服务器的数据
    self.sessionModel.downloadState = DownloadStateRunning;
    completionHandler(NSURLSessionResponseAllow);
}


/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
    //写入数据
    [self.sessionModel.stream write:data.bytes maxLength:data.length];
    //下载进度
    NSUInteger receivedSize = DownloadLength(self.sessionModel.urlString);
    NSUInteger expectedSize = self.sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize/expectedSize;
    self.sessionModel.process = progress;
    
    if (self.downloadProgressBlock) {
        self.downloadProgressBlock(progress,receivedSize, expectedSize);
    }
}


/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (!self.sessionModel) return;
    if ([self isCompletion:self.sessionModel.urlString]) {
        
        self.sessionModel.downloadState = DownloadStateCompleted;
        
        // 下载完成
        if (self.downloadCompleteBlock) {
            
            self.downloadCompleteBlock(DownloadStateCompleted,self.sessionModel.urlString);
        }

        if ([self.delegate respondsToSelector:@selector(downloadComplete:downloadUrlString:)]) {
    
            [self.delegate downloadComplete:DownloadStateCompleted downloadUrlString:self.sessionModel.urlString];
        }
    } else if (error){
        
        self.sessionModel.downloadState = DownloadStateFailed;
        
        // 下载失败
        if (self.downloadCompleteBlock) {
            
            self.downloadCompleteBlock(DownloadStateFailed,self.sessionModel.urlString);
        }
        
    }
    
    // 关闭流
    [self.sessionModel.stream close];
    self.sessionModel.stream = nil;
}



#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [self.downLoadTask cancel];
    
    if ([fileManager fileExistsAtPath:FileFullpath(url)]) {
        
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:FileFullpath(url) error:nil];
        
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:TotalLengthFullpath]) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:TotalLengthFullpath];
            [dict removeObjectForKey:FileName(url)];
            [dict writeToFile:TotalLengthFullpath atomically:YES];
        }
    }
}

@end
