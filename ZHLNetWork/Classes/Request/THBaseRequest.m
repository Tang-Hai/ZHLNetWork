//
//  THBaseRequest.m
//  我的网络层
//
//  Created by MAC on 2020/9/9.
//  Copyright © 2020 唐海. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "THBaseRequest.h"

@interface THBaseRequest ()

@end

@implementation THBaseRequest

#pragma mark - Init

+ (THBaseRequest *)requestPost:(NSString *)url {
    THBaseRequest *request = [[THBaseRequest alloc] init];
    request.methodType = THRequestTypePost;
    request.url = url;
    request.serializer = THRequestSerializerJsonType;
    return request;
}

+ (THBaseRequest *)requestGet:(NSString *)url {
    THBaseRequest *request = [[THBaseRequest alloc] init];
    request.methodType = THRequestTypeGet;
    request.url = url;
    request.serializer = THRequestSerializerJsonType;
    return request;
}

- (instancetype)init {
    self = [super init];
    if(self) {
      self.methodType = THRequestTypePost;
      self.serializer = THRequestSerializerJsonType;
    }
    return self;
}

#pragma mark - Get

- (NSString *)methodValue {
    return [THRequestProtocolTool methodValue:self.methodType];
}

#pragma mark - THRequestProtocol

- (NSURLRequest *)asURLRequestError:(NSError *__autoreleasing  *)error {

    NSAssert(self.url.length, @"url 不能为空");
    if(self.url.length == 0) {
        *error = [NSError errorWithDomain:NSURLErrorKey code:-500 userInfo:nil];
        return nil;
    }
    NSURL *url = nil;
    if([self.url hasPrefix:@"/"]) {
        url = [NSURL fileURLWithPath:self.url];
    } else {
        url = [NSURL URLWithString:self.url];
    }
    
    NSMutableURLRequest *mutableRequest = nil;
    AFHTTPRequestSerializer *serializer = [THRequestProtocolTool serializer:self.serializer];
    if(self.constructingBodyBlock) {
        mutableRequest = [serializer multipartFormRequestWithMethod:self.methodValue
                                                          URLString:url.absoluteString
                                                         parameters:self.parameters
                                          constructingBodyWithBlock:self.constructingBodyBlock error:error];
    } else {
        mutableRequest = [serializer
                          requestWithMethod:self.methodValue
                          URLString:url.absoluteString
                          parameters:self.parameters
                          error:error];
    }
    for (NSString *headerField in self.headerField.keyEnumerator) {
        [mutableRequest setValue:self.headerField[headerField] forHTTPHeaderField:headerField];
    }
    return mutableRequest;
}

#pragma mark - Set

- (THBaseRequest *)setConstructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block {
    _constructingBodyBlock = block;
    return self;
}

#pragma mark - Add

- (THBaseRequest *)addParameter:(NSDictionary *)parameter {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    if(self.parameters) {
        if(self.parameters) {
            [self.parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [dic setValue:obj forKey:key];
            }];
        }
    }
    self.parameters = dic;
    return self;
}

- (THBaseRequest *)addHeaderField:(NSDictionary *)parameter {
    NSMutableDictionary *headerField = [NSMutableDictionary dictionaryWithDictionary:parameter];
    if(self.headerField) {
        if(self.headerField) {
            [self.headerField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [headerField setValue:obj forKey:key];
            }];
        }
    }
    self.headerField = headerField;
    return self;
}

- (THBaseRequest *)addParameterValue:(NSString *)value key:(NSString *)key {
    if(value == nil || key == nil) {
        NSLog(@"异常的 parameters 插入， vlaue 或者 key 为 nil");
        return self;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:value forKey:key];
    if(self.parameters) {
        [self.parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [parameters setValue:obj forKey:key];
        }];
    }
    self.parameters = parameters;
    return self;
}

- (THBaseRequest *)addHeaderValue:(NSString *)value key:(NSString *)key {
    if(value == nil || key == nil) {
        NSLog(@"异常的 header 插入， vlaue 或者 key 为 nil");
        return self;
    }
    NSMutableDictionary *headerField = [NSMutableDictionary dictionary];
    [headerField setValue:value forKey:key];
    if(self.headerField) {
        [self.headerField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [headerField setValue:obj forKey:key];
        }];
    }
    self.headerField = headerField;
    return self;
}

@end
