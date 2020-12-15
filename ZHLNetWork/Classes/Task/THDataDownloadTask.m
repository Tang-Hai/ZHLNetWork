//
//  THDataDownloadTask.m
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/10.
//  Copyright © 2020 唐海. All rights reserved.
//

#import "THDataDownloadTask.h"

@implementation THDataDownloadTask

@dynamic completionHandlerArray,completionHandler;

#pragma mark - Action

- (THDataDownloadTask *)statr {
    return (THDataDownloadTask *)[super statr];
}
- (THDataDownloadTask *)suspend {
    return (THDataDownloadTask *)[super suspend];
}
- (THDataDownloadTask *)cancel {
    return (THDataDownloadTask *)[super cancel];
}
- (THDataDownloadTask *)retry:(NSInteger)count {
    return (THDataDownloadTask *)[super retry:count];
}

#pragma mark - Set

- (THDataDownloadTask *)setCancelBind:(id)obj {
    return (THDataDownloadTask *)[super setCancelBind:obj];
}

- (void)setRequestExecuteBlock:(void (^)(THDataDownloadTask *))requestExecuteBlock {
    [super setRequestExecuteBlock:^(THDataTask * _Nonnull dataTask) {
        requestExecuteBlock((THDataDownloadTask *)dataTask);
    }];
}

#pragma mark - Add Handler

- (THDataDownloadTask *)addUploadProgress:(THUploadProgressBlock)block {
    return (THDataDownloadTask *)[super addUploadProgress:block];
}
- (THDataDownloadTask *)addDownloadProgress:(THDownloadProgressBlock)block {
    return (THDataDownloadTask *)[super addDownloadProgress:block];
}
- (THDataDownloadTask *)addCompletionHandler:(THDownloadCompletionHandler)block {
    return (THDataDownloadTask *)[super addCompletionHandler:block];
}

@end
