//
//  THHTTPResponse.m
//  我的网络层
//
//  Created by MAC on 2020/9/14.
//  Copyright © 2020 唐海. All rights reserved.
//

#import "THHTTPResponse.h"

@implementation THHTTPResponse

- (void)success:(void(^)(id responseObject))success
          error:(void(^)(NSError *error))error {
    if(success) {
        success(self.responseObject);
    }
    if(error) {
        error(self.error);
    }
}

@end
