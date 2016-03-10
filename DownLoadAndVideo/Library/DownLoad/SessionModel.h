//
//  SessionModel.h
//  DownLoadAndVideo
//
//  Created by mistong on 16/3/8.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <Foundation/Foundation.h>

//下载状态枚举
typedef enum {

    DownloadStateRunning = 1,       /** 下载中 */
    DownloadStateSuspended =2,      /** 下载暂停 */
    DownloadStateCompleted =3,      /** 下载完成 */
    DownloadStateFailed  = 4        /** 下载失败 */

}DownloadState;

@interface SessionModel : NSObject

//添加字段
@property (nonatomic, strong)NSDictionary *extra;

//下载状态
@property (nonatomic, assign)DownloadState downloadState;

/**
 什么是Stream
 
 Stream翻译成为流，它是对我们读写文件的一个抽象。 你可以这样想象，当你读文件和写文件的时候，文件的内容就像水流一样哗哗的 像你流过来或者流给别人，这样岂不是很爽。 而Stream就帮我们做了这样的事情， 实际上，它是把文件的内容，一小段一小段的读出或 写入，来到达这样的效果

 NSStream 是Cocoa平台下对流这个概念的实现类， NSInputStream 和 NSOutputStream 则是它的两个子类，分别对应了读文件和 写文件。
 NSInputStream 对应的是读文件，所以要记住它是要将文件的内容读到内存(你声明的一段buffer)里,

 NSOutputStream 对应的是写文件，它是要将已存在的内存(buffer)里的数据写入文件,
 
 用途
 NSInputStream 和 NSOutputStream 常用与网络传输中，比如要将一个很大的文件传送给服务器，那么NSInputStream这时候是 很好的选择, 我们可以查看到 NSURLRequest 有一个属性叫HTTPBodyStream， 这时只要设置好一个NSInputStream的实例就可以 了，最大的好处就是可以节省我们很多的内存。
 另外要说明的是，NSInputStream 和 NSOutputStream其实是对 CoreFoundation 层对应的CFReadStreamRef 和 CFWriteStreamRef 的高层抽象。在使用CFNetwork时，常常会使用到CFReadStreamRef 与 CFWriteStreamRef。
 */

//读取 流
@property (nonatomic, strong)NSOutputStream *stream;

//下载地址
@property (nonatomic, strong)NSString       *urlString;

//存放地址
@property (nonatomic, strong)NSString       *downloadPath;

//获取服务器这次请求, 返回数据的总长度
@property (nonatomic, assign) u_int64_t     totalLength;

//下载进度
@property (nonatomic,  assign)NSInteger     process;

@end
