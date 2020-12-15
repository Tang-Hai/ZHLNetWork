//
//  THObserveUrlRequestPlug.h
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THRequestProtocol.h"
#import "THHTTPPlugProtocol.h"
#import "THDataTask.h"
NS_ASSUME_NONNULL_BEGIN

@interface THObserveUrlRequestPlug : NSObject<THHTTPPlugProtocol>

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) void(^willStartBlock)(id<THRequestProtocol>);
@property (copy, nonatomic) void(^completion)(id responseObject);

+ (instancetype)observeUrl:(NSString *)url
            willStartBlock:(void(^)(id<THRequestProtocol>))willStartBlock
                completion:(void(^)(id responseObject))completion;

@end

NS_ASSUME_NONNULL_END
