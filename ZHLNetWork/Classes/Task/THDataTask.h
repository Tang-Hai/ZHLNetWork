//
//  THDataTask.h
//  我的网络层
//
//  Created by MAC on 2020/9/10.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THHTTPPlugProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^THUploadProgressBlock)(NSProgress *uploadProgress);
typedef void(^THDownloadProgressBlock)(NSProgress *downloadProgress);
typedef void(^THCompletionHandler)(NSURLResponse * _Nullable response, id _Nullable responseObject,  NSError * _Nullable error);

@interface THDataTask : NSObject

@property (assign, nonatomic) NSInteger startIndex;
@property (assign, nonatomic) NSInteger retryIndex;
@property (strong, nonatomic, nullable) NSURLSessionTask *sessionDataTask;

@property (strong, nonatomic) id<THRequestProtocol> request;

@property (copy, nonatomic) THUploadProgressBlock uploadProgress;
@property (copy, nonatomic) THDownloadProgressBlock downloadProgress;
@property (copy, nonatomic) THCompletionHandler completionHandler;

#pragma mark - Observation

@property (copy, nonatomic) NSArray <THUploadProgressBlock>*uploadProgressArray;
@property (copy, nonatomic) NSArray <THDownloadProgressBlock>*downloadProgressArray;
@property (copy, nonatomic) NSArray <THCompletionHandler>*completionHandlerArray;
@property (copy, nonatomic) NSArray <id<THHTTPPlugProtocol>>*plugs;
@property (copy, nonatomic) NSArray <THDataTask *>*nextDataTask;
 
#pragma mark - Action

- (THDataTask *)statr;
- (THDataTask *)suspend;
- (THDataTask *)cancel;
- (THDataTask *)retry:(NSInteger)count;

#pragma mark - Set

- (THDataTask *)setCancelBind:(id)obj;
- (void)setRequestExecuteBlock:(void (^)(THDataTask *))requestExecuteBlock;

#pragma mark - Add Handler

- (THDataTask *)addPlug:(id<THHTTPPlugProtocol>)plug;
- (THDataTask *)addPlugs:(NSMutableArray <id<THHTTPPlugProtocol>>*)plugs;
- (THDataTask *)addUploadProgress:(THUploadProgressBlock)block;
- (THDataTask *)addDownloadProgress:(THDownloadProgressBlock)block;
- (THDataTask *)addCompletionHandler:(THCompletionHandler)block;
- (THDataTask *)addNextDataTask:(THDataTask *)dataTask;
@end

NS_ASSUME_NONNULL_END
