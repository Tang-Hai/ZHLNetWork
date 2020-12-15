//
//  THDataDownloadTask.h
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/10.
//  Copyright © 2020 唐海. All rights reserved.
//

#import "THDataTask.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^THDownloadCompletionHandler)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath,  NSError * _Nullable error);
typedef NSURL * _Nonnull(^THDownloadDestinationBlock)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response);

@interface THDataDownloadTask : THDataTask

@property (copy, nonatomic) THDownloadCompletionHandler completionHandler;
@property (copy, nonatomic) THDownloadDestinationBlock destinationBlock;
#pragma mark - Observation

@property (copy,nonatomic) NSArray <THDownloadCompletionHandler>*completionHandlerArray;

#pragma mark - Action

- (THDataDownloadTask *)statr;
- (THDataDownloadTask *)suspend;
- (THDataDownloadTask *)cancel;
- (THDataDownloadTask *)retry:(NSInteger)count;

#pragma mark - Set

- (THDataDownloadTask *)setCancelBind:(id)obj;
- (void)setRequestExecuteBlock:(void (^)(THDataDownloadTask *))requestExecuteBlock;

#pragma mark - Add Handler

- (THDataDownloadTask *)addUploadProgress:(THUploadProgressBlock)block;
- (THDataDownloadTask *)addDownloadProgress:(THDownloadProgressBlock)block;
- (THDataDownloadTask *)addCompletionHandler:(THDownloadCompletionHandler)block;

@end

NS_ASSUME_NONNULL_END
