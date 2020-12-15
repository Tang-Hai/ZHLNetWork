//
//  THObserveUrlRequestPlug.m
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import "THObserveUrlRequestPlug.h"

@implementation THObserveUrlRequestPlug

+ (instancetype)observeUrl:(NSString *)url
            willStartBlock:(void(^)(id<THRequestProtocol>))willStartBlock
                completion:(void(^)(id responseObject))completion {
    THObserveUrlRequestPlug *plug = [[THObserveUrlRequestPlug alloc] init];
    plug.url = url;
    plug.willStartBlock = willStartBlock;
    plug.completion = completion;
    return plug;
}

#pragma mark - THHTTPPlugProtocol

/// 插件执行优先级
- (THHTTPPlugPriority)priority {
    return THHTTPPlugLowPriority;
}

/// 将要开始请求 可以在这里修改请求数据
- (void)willStartWithRequest:(id<THRequestProtocol>)request {
    if([request.url isEqualToString:self.url] && self.willStartBlock) {
        self.willStartBlock(request);
    }
}

/// 结果已返回整个流程将要结束 可以对 responseObject 做处理 并返回
- (id)willDidWithResponse:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    if([response.URL.absoluteString isEqualToString:self.url] && self.completion) {
        self.completion(responseObject);
    }
    return responseObject;
}

/// 结果已返回整个流程将要结束 可以对 filePath 做处理 并返回
- (NSURL *)willDowloadDidWithResponse:(NSURLResponse * _Nullable)response filePath:(NSURL * _Nullable)filePath error:(NSError * _Nullable)error {
    if([response.URL.absoluteString isEqualToString:self.url] && self.completion) {
        self.completion(filePath);
    }
    return filePath;
}
@end
