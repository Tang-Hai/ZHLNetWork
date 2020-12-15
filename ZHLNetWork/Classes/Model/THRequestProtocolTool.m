//
//  THRequestProtocolTool.m
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import "THRequestProtocolTool.h"

@implementation THRequestProtocolTool

+ (NSString *)methodValue:(THRequestMethodType)type {
    switch (type) {
        case THRequestTypePost:
            return @"POST";
        case THRequestTypeGet:
            return @"GET";
        case THRequestTypeOptions:
            return @"OPTIONS";
        case THRequestTypeHead:
            return @"HEAD";
        case THRequestTypePut:
            return @"PUT";
        case THRequestTypePatch:
            return @"PATCH";
        case THRequestTypeDelete:
            return @"DELETE";
        case THRequestTypeTrace:
            return @"TRACE";
        case THRequestTypeconnect:
            return @"CONNECT";
    }
}

+ (THRequestMethodType)valueMethod:(NSString *)method {
    if([method isEqualToString:@"GET"]) {
        return THRequestTypeGet;
    } else if([method isEqualToString:@"OPTIONS"]) {
        return THRequestTypeOptions;
    } else if([method isEqualToString:@"HEAD"]) {
        return THRequestTypeHead;
    } else if([method isEqualToString:@"PUT"]) {
        return THRequestTypePut;
    } else if([method isEqualToString:@"PATCH"]) {
        return THRequestTypePut;
    } else if([method isEqualToString:@"DELETE"]) {
        return THRequestTypeDelete;
    } else if([method isEqualToString:@"TRACE"]) {
        return THRequestTypeTrace;
    } else if([method isEqualToString:@"CONNECT"]) {
        return THRequestTypeconnect;
    } else {
        return THRequestTypePost;
    }
}

+ (AFHTTPRequestSerializer *)serializer:(THRequestSerializerType)type {
    AFHTTPRequestSerializer *serializer = nil;
    switch (type) {
        case THRequestSerializerDefaultType: {
            serializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        case THRequestSerializerJsonType: {
            serializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case THPropertyListRequestSerializerType: {
            serializer = [AFPropertyListRequestSerializer serializer];
            break;
        }
    }
    return serializer;
}

@end
