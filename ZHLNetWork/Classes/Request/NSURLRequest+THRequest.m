//
//  NSURLRequest+THRequest.m
//  我的网络层_IOS
//
//  Created by MAC on 2020/9/11.
//  Copyright © 2020 唐海. All rights reserved.
//

#import "NSURLRequest+THRequest.h"

@implementation NSURLRequest (THRequest)
@dynamic methodType,serializer,url,parameters,headerField;
#pragma mark - THRequestProtocol

- (NSURLRequest *)asURLRequestError:(NSError *__autoreleasing  *)error {
    return self;
}

#pragma mark - Set

- (void)setMethodType:(THRequestMethodType)methodType {
  if([self isMemberOfClass:[NSMutableURLRequest class]]) {
      NSMutableURLRequest *mutableRequest = (NSMutableURLRequest *)self;
      mutableRequest.HTTPMethod = [THRequestProtocolTool methodValue:methodType];
  }
}

- (void)setSerializer:(THRequestSerializerType)serializer { }

- (void)setUrl:(NSString *)url { }

- (void)setParameters:(NSDictionary *)parameters { }

- (void)setHeaderField:(NSDictionary *)headerField {
    if([self isMemberOfClass:[NSMutableURLRequest class]]) {
        NSMutableURLRequest *mutableRequest = (NSMutableURLRequest *)self;
        for (NSString *key in headerField.keyEnumerator) {
            [mutableRequest setValue:headerField[key] forHTTPHeaderField:key];
        }
    }
}

#pragma mark - Get

- (THRequestMethodType)methodType {
    return [THRequestProtocolTool valueMethod:self.HTTPMethod];
}

- (THRequestSerializerType)serializer {
    return THRequestSerializerDefaultType;
}

- (NSString *)url {
    return self.URL.absoluteString;
}

- (NSDictionary *)parameters {
    return nil;
}

- (NSDictionary *)headerField {
    return self.allHTTPHeaderFields;
}

@end
