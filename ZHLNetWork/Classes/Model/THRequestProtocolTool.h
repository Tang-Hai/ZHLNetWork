//
//  THRequestProtocolTool.h
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "THRequestProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface THRequestProtocolTool : NSObject

+ (NSString *)methodValue:(THRequestMethodType)type;
+ (THRequestMethodType)valueMethod:(NSString *)method;
+ (AFHTTPRequestSerializer *)serializer:(THRequestSerializerType)type;

@end

NS_ASSUME_NONNULL_END
