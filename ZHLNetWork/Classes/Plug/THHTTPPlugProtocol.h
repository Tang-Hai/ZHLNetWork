//
//  THHTTPPlugProtocol.h
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THRequestProtocol.h"
NS_ASSUME_NONNULL_BEGIN

typedef NSInteger THHTTPPlugPriority;

static THHTTPPlugPriority THHTTPPlugLowPriority = 250;
static THHTTPPlugPriority THHTTPPlugMediumPriority = 750;
static THHTTPPlugPriority THHTTPPlugHighPriority = 1000;

@protocol THHTTPPlugProtocol <NSObject>
/// 插件执行优先级
- (THHTTPPlugPriority)priority;
@optional
/// 将要开始请求 可以在这里修改请求数据
- (void)willStartWithRequest:(id<THRequestProtocol>)request;
//// 即将开始请求 可以在这里修改 URLRequest
- (NSURLRequest *)startWithRequest:(NSMutableURLRequest *)request;
/// 结果已返回整个流程将要结束 可以对 responseObject 做处理 并返回
- (id)willDidWithResponse:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error;
/// 上传实时进度
- (void)uploadProgress:(NSProgress *)uploadProgress;
/// 下载实时进度
- (void)downloadProgress:(NSProgress *)downloadProgress;

#pragma mark - Data Dowload
/// 下载目录修改
- (NSURL *)changeDowloadWithTargetPath:(NSURL *)targetPath response:(NSURLResponse *)response;
/// 结果已返回整个流程将要结束 可以对 filePath 做处理 并返回
- (NSURL *)willDowloadDidWithResponse:(NSURLResponse * _Nullable)response filePath:(NSURL * _Nullable)filePath error:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
