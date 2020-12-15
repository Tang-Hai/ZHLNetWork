//
//  NSString+THRequest.m
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/10.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <objc/runtime.h>

#import "THBaseRequest.h"

#import "NSString+THRequest.h"

@interface NSString ()

@property (strong,nonatomic) THBaseRequest *baseRequest;

@end

@implementation NSString (THRequest)
@dynamic methodType,serializer,url,parameters,headerField;
#pragma mark - THRequestProtocol

- (NSURLRequest *)asURLRequestError:(NSError *__autoreleasing  *)error {
    return [self.baseRequest asURLRequestError:error];
}

#pragma mark - Set

- (void)setBaseRequest:(THBaseRequest *)baseRequest {
    objc_setAssociatedObject(self, _cmd, baseRequest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMethodType:(THRequestMethodType)methodType {
    self.baseRequest.methodType = methodType;
}

- (void)setSerializer:(THRequestSerializerType)serializer {
    self.baseRequest.serializer = serializer;
}

- (void)setUrl:(NSString *)url {
    self.baseRequest.url = url;
}

- (void)setParameters:(NSDictionary *)parameters {
    self.baseRequest.parameters = parameters;
}

- (void)setHeaderField:(NSDictionary *)headerField {
    self.baseRequest.headerField = headerField;
}

#pragma mark - Get

- (THRequestMethodType)methodType {
    return self.baseRequest.methodType;
}

- (THRequestSerializerType)serializer {
    return self.baseRequest.serializer;
}

- (NSString *)url {
    return self.baseRequest.url;
}

- (NSDictionary *)parameters {
    return self.baseRequest.parameters;
}

- (NSDictionary *)headerField {
    return self.baseRequest.headerField;
}

- (THBaseRequest *)baseRequest {
    THBaseRequest *baseRequest = objc_getAssociatedObject(self, _cmd);
    if(!baseRequest) {
        baseRequest = [THBaseRequest requestGet:self];
    }
    return baseRequest;
}

@end


