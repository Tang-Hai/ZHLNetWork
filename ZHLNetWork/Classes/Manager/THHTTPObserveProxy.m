//
//  THHTTPObserveProxy.m
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import "THHTTPObserveProxy.h"

@implementation THHTTPObserveProxy

+ (instancetype)proxy:(id)obj {
    THHTTPObserveProxy *proxy = [[self alloc] init];
    proxy.obj = obj;
    return proxy;
}

@end
