//
//  THHTTPManager.m
//  我的网络层
//
//  Created by MAC on 2020/9/10.
//  Copyright © 2020 唐海. All rights reserved.
//
#import "THHTTPObserveProxy.h"

#import "THHTTPManager.h"

@interface THHTTPManager ()

@property (strong, nonatomic) NSMutableArray <THDataTask *>*tasks;

@property (strong, nonatomic) NSMutableArray <id<THHTTPPlugProtocol>>*plugs;

@property (strong, nonatomic) NSMutableArray <THHTTPObserveProxy *>*observeRequests;

@end

@implementation THHTTPManager

#pragma mark - Tool

+ (THHTTPManager *)manager {
    static THHTTPManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[THHTTPManager alloc] init];
        _manager.manager = [AFHTTPSessionManager manager];
        _manager.manager.operationQueue.maxConcurrentOperationCount = 6;
        _manager.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return _manager;
}

#pragma mark - Plus

+ (NSMutableArray <id<THHTTPPlugProtocol>>*)getAllPlus {
    return self.manager.plugs;
}

+ (id<THHTTPPlugProtocol>)getPlusWithIndex:(NSInteger)index {
    if(index < self.manager.plugs.count) {
        return self.manager.plugs[index];
    }
    return nil;
}

+ (void)addPlug:(id<THHTTPPlugProtocol>)plug {
    [self.manager.plugs addObject:plug];
}

+ (void)reomvePlug:(id<THHTTPPlugProtocol>)plug {
    [self.manager.plugs removeObject:plug];
}

#pragma mark - Data Task

+ (THDataTask *)request:(id<THRequestProtocol>)request parameters:(NSDictionary *)parameters {
    return [self request:request parameters:parameters headerField:nil];
}

+ (THDataTask *)request:(id<THRequestProtocol>)request parameters:(NSDictionary *)parameters headerField:(NSDictionary *)headerField {
    if(parameters.count) {
        NSMutableDictionary *parameters_new = [request.parameters mutableCopy];
        [parameters_new setDictionary:parameters];
        request.parameters = parameters_new;
    }
    if(headerField.count) {
        NSMutableDictionary *headerField_new = [request.headerField mutableCopy];
        [headerField_new setDictionary:headerField];
        request.headerField = headerField_new;
    }
    return [self request:request];
}

+ (THDataTask *)request:(id<THRequestProtocol>)request {
    THDataTask *task = [[THDataTask alloc] init];
    task.request = request;
    [task setRequestExecuteBlock:^(THDataTask * _Nonnull task) {
        [task addPlugs:self.manager.plugs];
        [task.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj respondsToSelector:@selector(willStartWithRequest:)]) {
                [obj willStartWithRequest:request];
            }
        }];
        NSError *error = nil;
        __block NSURLRequest *urlRequest = [request asURLRequestError:&error];
        [task.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj respondsToSelector:@selector(startWithRequest:)]) {
                urlRequest = [obj startWithRequest:[urlRequest mutableCopy]];
            }
        }];
        if(error) {
            if (task.completionHandler) {
                dispatch_async(self.manager.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                    task.completionHandler(nil, nil, error);
                });
            }
        } else {
            if(![self.manager.tasks containsObject:task]) {
                [self.manager.tasks addObject:task];
            }
            __weak typeof(task)weakTask = task;
            task.sessionDataTask =  [self.manager.manager dataTaskWithRequest:urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                [weakTask.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj respondsToSelector:@selector(uploadProgress:)]) {
                        [obj uploadProgress:uploadProgress];
                    }
                }];
                if(weakTask.uploadProgress) {
                    weakTask.uploadProgress(uploadProgress);
                }
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                [weakTask.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj respondsToSelector:@selector(downloadProgress:)]) {
                        [obj downloadProgress:downloadProgress];
                    }
                }];
                if(weakTask.downloadProgress) {
                    weakTask.downloadProgress(downloadProgress);
                }
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                __block id responseObjectValue = responseObject;
                [weakTask.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj respondsToSelector:@selector(willDidWithResponse:responseObject:error:)]) {
                        responseObjectValue = [obj willDidWithResponse:response responseObject:responseObjectValue error:error];
                    }
                }];
                if(weakTask.completionHandler) {
                    dispatch_async(self.manager.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                        __strong typeof(weakTask)stongTask = weakTask;
                        stongTask.completionHandler(response, responseObjectValue, error);
                        [self.manager.tasks removeObject:weakTask];
                    });
                } else {
                    [self.manager.tasks removeObject:weakTask];
                }
            }];
            task.startIndex += 1;
            [task.sessionDataTask resume];
        }
    }];
    return task;
}

#pragma mark - Data Download

+ (THDataTask *)download:(id<THRequestProtocol>)request parameters:(NSDictionary *)parameters {
    return [self download:request parameters:parameters headerField:nil];
}

+ (THDataTask *)download:(id<THRequestProtocol>)request parameters:(NSDictionary *)parameters headerField:(NSDictionary *)headerField {
    if(parameters.count) {
        NSMutableDictionary *parameters_new = [request.parameters mutableCopy];
        [parameters_new setDictionary:parameters];
        request.parameters = parameters_new;
    }
    if(headerField.count) {
        NSMutableDictionary *headerField_new = [request.headerField mutableCopy];
        [headerField_new setDictionary:headerField];
        request.headerField = headerField_new;
    }
    return [self download:request];
}

+ (THDataDownloadTask *)download:(id<THRequestProtocol>)request {
    THDataDownloadTask *task = [[THDataDownloadTask alloc] init];
    task.request = request;
    [task setRequestExecuteBlock:^(THDataDownloadTask * _Nonnull task) {
        [task addPlugs:self.manager.plugs];
        [task.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj respondsToSelector:@selector(willStartWithRequest:)]) {
                [obj willStartWithRequest:request];
            }
        }];
        NSError *error = nil;
        __block NSURLRequest *urlRequest = [request asURLRequestError:&error];
        [task.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj respondsToSelector:@selector(startWithRequest:)]) {
                urlRequest = [obj startWithRequest:[urlRequest mutableCopy]];
            }
        }];
        if(error) {
            if (task.completionHandler) {
                dispatch_async(self.manager.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                    task.completionHandler(nil, nil, error);
                });
            }
        } else {
            if(![self.manager.tasks containsObject:task]) {
                [self.manager.tasks addObject:task];
            }
            __weak typeof(task)weakTask = task;
            task.sessionDataTask = [self.manager.manager downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
                [weakTask.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj respondsToSelector:@selector(downloadProgress:)]) {
                        [obj downloadProgress:downloadProgress];
                    }
                }];
                if(task.downloadProgress) {
                    task.downloadProgress(downloadProgress);
                }
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                __block NSURL *myTargetPath = targetPath;
                [weakTask.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj respondsToSelector:@selector(changeDowloadWithTargetPath:response:)]) {
                        myTargetPath = [obj changeDowloadWithTargetPath:myTargetPath response:response];
                    }
                }];
                if(weakTask.destinationBlock) {
                    weakTask.destinationBlock(myTargetPath, response);
                }
                return myTargetPath;
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                __block NSURL *filePathValue = filePath;
                [weakTask.plugs enumerateObjectsUsingBlock:^(id<THHTTPPlugProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj respondsToSelector:@selector(willDowloadDidWithResponse:filePath:error:)]) {
                        filePathValue = [obj willDowloadDidWithResponse:response filePath:filePathValue error:error];
                    }
                }];
                if(weakTask.completionHandler) {
                    dispatch_async(self.manager.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                        __strong typeof(weakTask)stongTask = weakTask;
                        [self.manager.tasks removeObject:weakTask];
                        stongTask.completionHandler(response, filePathValue, error);
                    });
                } else {
                    [self.manager.tasks removeObject:weakTask];
                }
            }];
            task.startIndex += 1;
            [task.sessionDataTask resume];
        }
    }];
    return task;
}

#pragma mark - Data Upload

+ (THDataTask *)upload:(id<THRequestProtocol>)request {
    return [self request:request];
}

+ (THDataTask *)upload:(id<THRequestProtocol>)request
            parameters:(NSDictionary * _Nullable)parameters {
    return [self upload:request parameters:parameters headerField:nil];
}

+ (THDataTask *)upload:(id<THRequestProtocol>)request
             parameters:(NSDictionary * _Nullable)parameters
           headerField:(NSDictionary * _Nullable)headerField {
    return [self request:request parameters:parameters headerField:headerField];
}

#pragma mark - Observe

+ (THObserveUrlRequestPlug *)addObserveUrlPlug:(NSString *)url
           willStartBlock:(void(^)(id<THRequestProtocol>))willStartBlock
               completion:(void(^)(id responseObject))completion {
    THObserveUrlRequestPlug *plug = [THObserveUrlRequestPlug observeUrl:url willStartBlock:willStartBlock completion:completion];
    [self addPlug:plug];
    return plug;
}

+ (void)observeCompletionNotificationFromTasks:(NSArray <THDataTask *>*)tasks completion:(void(^)(NSArray <THDataTask *>*))completion {
    NSMutableArray <THHTTPObserveProxy *>*proxys = [[NSMutableArray alloc] initWithCapacity:tasks.count];
    [tasks enumerateObjectsUsingBlock:^(THDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [proxys addObject:[THHTTPObserveProxy proxy:obj]];
    }];
    __block BOOL allCompletion = NO;
    [tasks enumerateObjectsUsingBlock:^(THDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addCompletionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
            __block BOOL allBool = YES;
            [proxys enumerateObjectsUsingBlock:^(THHTTPObserveProxy * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                THDataTask *task = obj.obj;
                if(task && (task.sessionDataTask.state == NSURLSessionTaskStateRunning ||
                            task.sessionDataTask.state == NSURLSessionTaskStateSuspended ||
                            task.sessionDataTask == nil)) {
                    allBool = NO;
                }
            }];
            if(allBool) {
                NSMutableArray <THDataTask *>*tasks = [[NSMutableArray alloc] initWithCapacity:proxys.count];
                [proxys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tasks addObject:obj];
                }];
                if(completion && allCompletion == NO) {
                    allCompletion = YES;
                    dispatch_async(self.manager.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                        completion(tasks);
                    });
                }
            }
        }];
    }];
}

#pragma mark - Get

-(NSMutableArray<THDataTask *> *)tasks {
    if(!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

- (NSMutableArray<id<THHTTPPlugProtocol>> *)plugs {
    if(!_plugs) {
        _plugs = [NSMutableArray array];
    }
    return _plugs;
}

@end
