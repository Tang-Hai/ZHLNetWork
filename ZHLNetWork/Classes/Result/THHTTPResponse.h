//
//  THHTTPResponse.h
//  我的网络层
//
//  Created by MAC on 2020/9/14.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THHTTPResponse : NSObject

@property (strong, nonatomic) NSError *error;

@property (strong, nonatomic) id responseObject;

@property (strong, nonatomic) NSURLResponse *response;

- (void)success:(void(^)(id responseObject))success
          error:(void(^)(NSError *error))error;

@end

NS_ASSUME_NONNULL_END
