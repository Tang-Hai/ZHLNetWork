//
//  THHTTPObserveProxy.h
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THHTTPObserveProxy : NSObject

@property (weak,nonatomic) id obj;

+ (instancetype)proxy:(id)obj;

@end

NS_ASSUME_NONNULL_END
