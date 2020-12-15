//
//  NSURLRequest+THRequest.h
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THRequestProtocolTool.h"
#import "THRequestProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (THRequest)<THRequestProtocol>

@property (assign, nonatomic) THRequestMethodType methodType;

@property (nonatomic, assign) THRequestSerializerType serializer;

@property (copy, nonatomic) NSString *url;

@property (copy, nonatomic) NSDictionary *parameters;

@property (copy, nonatomic) NSDictionary *headerField;

- (NSURLRequest *)asURLRequestError:(NSError *__autoreleasing  *)error;

@end

NS_ASSUME_NONNULL_END
