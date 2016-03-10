//
//  DownloadTask.h
//  DownLoadAndVideo
//
//  Created by mistong on 16/3/8.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownloadEntity.h"
#import "SessionModel.h"

//缓存主目录
#define CachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZWZCache"]

// 保存文件名
#define FileName(url) [[url componentsSeparatedByString:@"/"] lastObject]

// 文件的存放路径（caches）
#define FileFullpath(url) [CachesDirectory stringByAppendingPathComponent:FileName(url)]

// 文件的已下载长度
#define DownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:FileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件总长度的文件路径（caches）
#define TotalLengthFullpath [CachesDirectory stringByAppendingPathComponent:@"totalLength.plist"]

@protocol DownloadTaskDelegate <NSObject>

-(void)downloadComplete:(DownloadState)downloadState downloadUrlString:(NSString *)downloadUrlString;

@end

/**
 *  下载进度回调
 *
 *  @param progress            进度
 *  @param totalRead           总红色条
 *  @param totalExpectedToRead 总进展红色条
 */
typedef void(^DownloadProgressBlock)(CGFloat progress, CGFloat totalRead, CGFloat totalExpectedToRead);

/**
 *  下载完成度回调, 判断是否可以下载,下载中, 下载完成
 *
 *  @param downloadState     下载状态
 *  @param downloadUrlString 下载地址
 */
typedef void(^DownloadCompleteBlock)(DownloadState downloadState, NSString *downloadUrlString);

@interface DownloadTask : NSObject

//声明DownloadTaskDelegate delegate   用weak, 防止assign野指针 和 strong的系统崩溃
@property (nonatomic, weak)id <DownloadTaskDelegate> delegate;


//Block属性的声明，首先需要用copy修饰符，因为只有copy后的Block才会在堆中，栈中的Block的生命周期是和栈绑定的，
@property (nonatomic, copy)DownloadProgressBlock downloadProgressBlock;

@property (nonatomic, copy)DownloadCompleteBlock downloadCompleteBlock;

//NSURLSession类支持三种类型的任务：加载数据，下载和上传。
@property (nonatomic, strong)NSURLSession *sesssion;

//下载相关信息
@property (nonatomic, strong)SessionModel *sessionModel;

//下载任务
@property (nonatomic, strong)NSURLSessionDataTask *downLoadTask;

/**
 *  添加下载任务并下载
 *
 *  @param downloadEntity 类
 *
 *  @return 状态
 */
- (DownloadState)addTaskWithDownLoad:(DownloadEntity *)downloadEntity;

/**
 *  <#Description#>
 *
 *  @param url           地址
 *  @param progressBlock 进度
 *  @param completeBlock 完成进度
 *  @param downloadState 状态
 */
- (void)downLoad:(NSString *)url progressBlock:(DownloadProgressBlock)progressBlock completeBlock:(DownloadCompleteBlock)completeBlock downloadState:(DownloadState)downloadState;

/**
 *  查询该资源的下载进度
 *
 *  @param url
 *
 *  @return cgfloat
 */
- (CGFloat)progress:(NSString *)url;

/**
 *  判断该文件是否下载完成
 */
- (BOOL)isCompletion:(NSString *)url;


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
 */
- (void)deleteFile:(NSString *)url;


@end
