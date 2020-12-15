//
//  THDataTask.m
//  我的网络层
//
//  Created by MAC on 2020/9/10.
//  Copyright © 2020 唐海. All rights reserved.
//

#import "THHTTPObserveProxy.h"

#import "THDataTask.h"

@interface THDataTask ()

@property (assign, nonatomic) NSInteger retry;
@property (copy, nonatomic) void(^requestExecuteBlock)(THDataTask *);

@property (strong, nonatomic) THHTTPObserveProxy *autoCancelBindProxy;

@property (strong, nonatomic) NSURLResponse *response;
@property (strong, nonatomic) id responseObject;
@property (strong, nonatomic) NSError *error;

@end

@implementation THDataTask

- (void)dealloc {
    NSLog(@"THDataTask 释放啦");
}

#pragma nark Init

- (instancetype)init {
    self = [super init];
    if(self) {
        __weak typeof(self)weakSelf = self;
        self.uploadProgress = ^(NSProgress * _Nonnull uploadProgress) {
            NSArray <THUploadProgressBlock>*uploadProgressArray = [weakSelf.uploadProgressArray mutableCopy];
            [uploadProgressArray enumerateObjectsUsingBlock:^(THUploadProgressBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj(uploadProgress);
            }];
            if(weakSelf.autoCancelBindProxy && !weakSelf.autoCancelBindProxy.obj) {
                [weakSelf.sessionDataTask cancel];
            }
        };
        self.downloadProgress = ^(NSProgress * _Nonnull downloadProgress) {
            NSArray <THUploadProgressBlock>*downloadProgressArray = [weakSelf.downloadProgressArray mutableCopy];
            [downloadProgressArray enumerateObjectsUsingBlock:^(THUploadProgressBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj(downloadProgress);
            }];
            if(weakSelf.autoCancelBindProxy && !weakSelf.autoCancelBindProxy.obj) {
                [weakSelf.sessionDataTask cancel];
            }
        };
        self.completionHandler = ^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if(weakSelf.retry == weakSelf.retryIndex || error.code == NSURLErrorCancelled || !error || (weakSelf.autoCancelBindProxy && !weakSelf.autoCancelBindProxy.obj)) {
                NSArray <THCompletionHandler>*completionHandlerArray = [weakSelf.completionHandlerArray mutableCopy];
                [completionHandlerArray enumerateObjectsUsingBlock:^(THCompletionHandler  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj(response,responseObject,error);
                }];
                weakSelf.retryIndex = 0;
                [weakSelf.nextDataTask enumerateObjectsUsingBlock:^(THDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj statr];
                }];
            } else {
                weakSelf.sessionDataTask = nil;
                weakSelf.retryIndex += 1;
                [weakSelf statr];
                NSLog(@"重试第%@",@(weakSelf.retryIndex));
            }
        };
    }
    return self;
}

#pragma mark - Action

- (THDataTask *)statr {
    if(!self.sessionDataTask) {
        self.requestExecuteBlock(self);
    } else if (self.sessionDataTask.state == NSURLSessionTaskStateCanceling || self.sessionDataTask.state == NSURLSessionTaskStateCompleted) {
        self.completionHandler(self.response, self.responseObject, self.error);
    }
    return self;
}

- (THDataTask *)suspend {
    [self.sessionDataTask suspend];
    return self;
}

- (THDataTask *)cancel {
    [self.sessionDataTask cancel];
    return self;
}

- (THDataTask *)retry:(NSInteger)count {
    _retry = count;
    return self;
}

#pragma mark - Set

- (void)setRequestExecuteBlock:(void (^)(THDataTask *))requestExecuteBlock {
    _requestExecuteBlock = requestExecuteBlock;
}

- (THDataTask *)setCancelBind:(id)obj {
    THHTTPObserveProxy *proxy = [[THHTTPObserveProxy alloc] init];
    proxy.obj = obj;
    self.autoCancelBindProxy = proxy;
    return self;
}

#pragma mark - Add Handler

- (THDataTask *)addPlugs:(NSMutableArray <id<THHTTPPlugProtocol>>*)plugs {
    NSMutableSet *set = [NSMutableSet setWithArray:self.plugs];
    [set addObjectsFromArray:plugs];
    NSMutableArray <id<THHTTPPlugProtocol>>*allPlugs = [(id)set.allObjects mutableCopy];
    [allPlugs sortUsingComparator:^NSComparisonResult(id <THHTTPPlugProtocol> _Nonnull obj1, id <THHTTPPlugProtocol> _Nonnull obj2) {
        return obj1.priority > obj2.priority;
    }];
    self.plugs = allPlugs;
    return self;
}

- (THDataTask *)addPlug:(id<THHTTPPlugProtocol>)plug {
    NSMutableArray <id<THHTTPPlugProtocol>>*plugs = [NSMutableArray arrayWithObject:plug];
    return [self addPlugs:plugs];
}

- (THDataTask *)addUploadProgress:(THUploadProgressBlock)block {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:block];
    [array addObjectsFromArray:self.uploadProgressArray];
    self.uploadProgressArray = array;
    return self;
}

- (THDataTask *)addDownloadProgress:(THDownloadProgressBlock)block {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:block];
    [array addObjectsFromArray:self.downloadProgressArray];
    self.downloadProgressArray = array;
    return self;
}

- (THDataTask *)addCompletionHandler:(THCompletionHandler)block {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:block];
    [array addObjectsFromArray:self.completionHandlerArray];
    self.completionHandlerArray = array;
    return self;
}

- (THDataTask *)addNextDataTask:(THDataTask *)dataTask {
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:self.nextDataTask];
    [dataTasks addObject:dataTask];
    self.nextDataTask = dataTasks;
    return self;
}

@end
