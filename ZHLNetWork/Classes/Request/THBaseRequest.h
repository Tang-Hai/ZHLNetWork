//
//  THBaseRequest.h
//  我的网络层
//
//  Created by MAC on 2020/9/9.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "THRequestProtocol.h"
#import "THRequestProtocolTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface THBaseRequest : NSObject<THRequestProtocol>

@property (assign, nonatomic) THRequestMethodType methodType;

@property (nonatomic, assign) THRequestSerializerType serializer;

@property (copy, nonatomic) NSString *url;

@property (copy, nonatomic) NSDictionary *parameters;

@property (copy, nonatomic) NSDictionary *headerField;

@property (copy, nonatomic) void(^constructingBodyBlock)(id<AFMultipartFormData> _Nonnull);

#pragma mark - Init

+ (THBaseRequest *)requestPost:(NSString *)url;
+ (THBaseRequest *)requestGet:(NSString *)url;

#pragma mark - Get

- (NSString *)methodValue;
- (NSURLRequest *)asURLRequestError:(NSError *__autoreleasing  *)error;

#pragma mark - Set

- (THBaseRequest *)setConstructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block;

#pragma mark - Add

- (THBaseRequest *)addParameter:(NSDictionary *)parameter;
- (THBaseRequest *)addHeaderField:(NSDictionary *)parameter;
- (THBaseRequest *)addParameterValue:(NSString *)value key:(NSString *)key;
- (THBaseRequest *)addHeaderValue:(NSString *)value key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
