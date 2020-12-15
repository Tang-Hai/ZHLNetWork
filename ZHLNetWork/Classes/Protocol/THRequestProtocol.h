//
//  THRequestProtocol.h
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/10.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    THRequestTypePost,
    THRequestTypeGet,
    THRequestTypeOptions,
    THRequestTypeHead,
    THRequestTypePut,
    THRequestTypePatch,
    THRequestTypeDelete,
    THRequestTypeTrace,
    THRequestTypeconnect
} THRequestMethodType;

typedef enum : NSUInteger {
    THRequestSerializerDefaultType,
    THRequestSerializerJsonType,
    THPropertyListRequestSerializerType
} THRequestSerializerType;

NS_ASSUME_NONNULL_BEGIN

@protocol THRequestProtocol <NSObject>

@property (assign, nonatomic) THRequestMethodType methodType;

@property (nonatomic, assign) THRequestSerializerType serializer;

@property (copy, nonatomic) NSString *url;

@property (copy, nonatomic) NSDictionary *parameters;

@property (copy, nonatomic) NSDictionary *headerField;

- (NSURLRequest *)asURLRequestError:(NSError *__autoreleasing  *)error;

@end

NS_ASSUME_NONNULL_END
