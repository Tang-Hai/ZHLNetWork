//
//  THHTTPManager.h
//  我的网络层
//
//  Created by MAC on 2020/9/10.
//  Copyright © 2020 唐海. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>
#import "THDataTask.h"
#import "THDataDownloadTask.h"
#import "THRequestProtocol.h"
#import "NSString+THRequest.h"
#import "THHTTPPlugProtocol.h"
#import "THObserveUrlRequestPlug.h"
NS_ASSUME_NONNULL_BEGIN

@interface THHTTPManager : NSObject

@property (strong, nonatomic) AFHTTPSessionManager *manager;

#pragma mark - Manager

+ (THHTTPManager *)manager;

#pragma mark - Data Task

+ (THDataTask *)request:(id<THRequestProtocol>)request;

+ (THDataTask *)request:(id<THRequestProtocol>)request
             parameters:(NSDictionary * _Nullable)parameters;

+ (THDataTask *)request:(id<THRequestProtocol>)request
             parameters:(NSDictionary * _Nullable)parameters
            headerField:(NSDictionary * _Nullable)headerField;

#pragma mark - Data Download

+ (THDataDownloadTask *)download:(id<THRequestProtocol>)request;

+ (THDataTask *)download:(id<THRequestProtocol>)request
              parameters:(NSDictionary * _Nullable)parameters;

+ (THDataTask *)download:(id<THRequestProtocol>)request
              parameters:(NSDictionary * _Nullable)parameters
             headerField:(NSDictionary * _Nullable)headerField;

#pragma mark - Data Upload

+ (THDataTask *)upload:(id<THRequestProtocol>)request;

+ (THDataTask *)upload:(id<THRequestProtocol>)request
             parameters:(NSDictionary * _Nullable)parameters;

+ (THDataTask *)upload:(id<THRequestProtocol>)request
             parameters:(NSDictionary * _Nullable)parameters
            headerField:(NSDictionary * _Nullable)headerField;

#pragma mark - Plus

+ (void)addPlug:(id<THHTTPPlugProtocol>)plug;
+ (void)reomvePlug:(id<THHTTPPlugProtocol>)plug;

+ (NSMutableArray <id<THHTTPPlugProtocol>>*)getAllPlus;
+ (id<THHTTPPlugProtocol>)getPlusWithIndex:(NSInteger)index;

#pragma mark - Observe

+ (THObserveUrlRequestPlug *)addObserveUrlPlug:(NSString *)url
           willStartBlock:(void(^)(id<THRequestProtocol>))willStartBlock
               completion:(void(^)(id responseObject))completion;

+ (void)observeCompletionNotificationFromTasks:(NSArray <THDataTask *>*)tasks
                                    completion:(void(^)(NSArray <THDataTask *>*))completion;
@end

NS_ASSUME_NONNULL_END
