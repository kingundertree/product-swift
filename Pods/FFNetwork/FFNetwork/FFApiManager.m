//
//  FFApiManager.m
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFApiManager.h"
#import "FFRequestGenerator.h"
#import "FFNetDebug.h"
#import "AFHTTPRequestOperationManager.h"

@interface FFApiManager ()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@end

@implementation FFApiManager

+ (id)shareInstance{
    static dispatch_once_t pred;
    static FFApiManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[FFApiManager alloc] init];
    });
    return sharedInstance;
}

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPRequestOperationManager *)operationManager
{
    if (_operationManager == nil) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _operationManager;
}

- (FFRequestResponse *)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:servieIdentifier];
    
    if (service.isREST) {
        return nil;
    }
    
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    return [self callApiWithRequestSynchronously:request];
}

- (FFRequestResponse *)callPostWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:servieIdentifier];
    
    if (service.isREST) {
        return nil;
    }
    
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generatePostRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    return [self callApiWithRequestSynchronously:request];
}

#pragma mark - public methods
- (FFRequestResponse *)callApiWithRequestSynchronously:(NSURLRequest *)request
{
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    FFRequestResponse *FFResponse = [[FFRequestResponse alloc] initWithResponseString:nil
                                                                            requestId:@(-1)
                                                                              request:request
                                                                         responseData:data
                                                                                error:error];
    [FFNetDebug logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                           resposeString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
                                 request:request
                                   error:error];
    return FFResponse;
}

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail
{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:servieIdentifier];
    
    if (service.isREST) {
        return 0;
    }
    
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}


- (NSInteger)callPostWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail
{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:servieIdentifier];
    
    if (service.isREST) {
        return 0;
    }
    
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generatePostRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail{
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateRestfulGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    
    return [requestId integerValue];
}

- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail{
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateRestfulPOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    
    return [requestId integerValue];
}

- (FFRequestResponse *)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName
{
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateRestfulPOSTRequestWithServiceIdentifier:servieIdentifier
                                                                                                   requestParams:params
                                                                                                      methodName:methodName];
    return [self callApiWithRequestSynchronously:request];
}

- (FFRequestResponse *)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName
{
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateRestfulGETRequestWithServiceIdentifier:servieIdentifier
                                                                                                  requestParams:params
                                                                                                     methodName:methodName];
    return [self callApiWithRequestSynchronously:request];
}

#pragma mark - private methods
/** AFNetworking 核心功能 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(FFCallback)success fail:(FFCallback)fail
{
    // 之所以不用getter，是因为如果放到getter里面的话，每次调用self.recordedRequestId的时候值就都变了，违背了getter的初衷
    NSNumber *requestId = [self generateRequestId];
    //    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
    
    // 跑到这里的block的时候，就已经是主线程了。
    AFHTTPRequestOperation *httpRequestOperation = [self.operationManager HTTPRequestOperationWithRequest:request
                                                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                    {
                                                        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
                                                        if (storedOperation == nil)
                                                        {
                                                            // 如果这个operation是被cancel的，那就不用处理回调了。
                                                            return;
                                                        } else {
                                                            [self.dispatchTable removeObjectForKey:requestId];
                                                        }
                                                        
                                                        [FFNetDebug logDebugInfoWithResponse:operation.response
                                                                               resposeString:operation.responseString
                                                                                     request:operation.request
                                                                                       error:NULL];
                                                        
                                                        FFRequestResponse *response = [[FFRequestResponse alloc]
                                                                                       initWithResponseString:operation.responseString
                                                                                       requestId:requestId
                                                                                       request:operation.request
                                                                                       responseData:operation.responseData
                                                                                       status:FFNetWorkingResponseStatusSuccess];
                                                        
                                                        //        [self performanceWithResponse:response totalTime:[NSDate timeIntervalSinceReferenceDate] - time responseCode:operation.response.statusCode];
                                                        
                                                        if (operation.response.statusCode >= 200  && operation.response.statusCode < 300) {
                                                            success?success(response):nil;
                                                        } else {
                                                            // TODO: 先支持httpStatus，具体要做什么 等API后续 operation.response.statusCode
                                                            // 之后可能会支持 301， 304等
                                                            
                                                            // 性能日志
                                                            //            if ([AIFPerformanceConfig shared].config.exception.http) {
                                                            //                [AIFPerformanceReporter reportWithModel:[AIFPerformanceModel modelWithType:AIFPerformanceLogTypeException
                                                            //                                                                                   content:AIFPerformanceContentTypeApi
                                                            //                                                                                    values:@{
                                                            //                                                                                             @"url":[request.URL absoluteString],
                                                            //                                                                                             @"content":@"",
                                                            //                                                                                             @"responseCode":@(operation.response.statusCode)
                                                            //                                                                                             }]];
                                                            //            }
                                                            
                                                            fail?fail(response):nil;
                                                        }
                                                        
                                                    }failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                                    {
                                                        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
                                                        if (storedOperation == nil) {
                                                            // 如果这个operation是被cancel的，那就不用处理回调了。
                                                            return;
                                                        } else {
                                                            [self.dispatchTable removeObjectForKey:requestId];
                                                        }
                                                        
                                                        [FFNetDebug logDebugInfoWithResponse:operation.response
                                                                               resposeString:operation.responseString
                                                                                     request:operation.request
                                                                                       error:error];
                                                        
                                                        FFRequestResponse *response = [[FFRequestResponse alloc]
                                                                                       initWithResponseString:operation.responseString
                                                                                       requestId:requestId
                                                                                       request:operation.request
                                                                                       responseData:operation.responseData
                                                                                       error:error];
                                                        //        [self performanceWithResponse:response
                                                        //                            totalTime:[NSDate timeIntervalSinceReferenceDate] - time
                                                        //                         responseCode:operation.response.statusCode];
                                                        
                                                        fail?fail(response):nil;
                                                    }];
    
    self.dispatchTable[requestId] = httpRequestOperation;
    [[self.operationManager operationQueue] addOperation:httpRequestOperation];
    return requestId;
}

//- (void)performanceWithResponse:(AIFURLResponse *)response totalTime:(double)time responseCode:(NSUInteger)code
//{
//    if (![AIFPerformanceConfig shared].config.performance.api) {
//        return;
//    }
//    
//    double serverTime = 0;
//    NSDictionary *responseDic = response.content;
//    if ([responseDic isKindOfClass:[NSDictionary class]] &&
//        responseDic[@"requestTime"]) {
//        serverTime = [responseDic[@"requestTime"] doubleValue];
//    }
//    
//    AIFPerformanceModel *model = [AIFPerformanceModel apiPerformanceModelWithTime:time * 1000
//                                                                              url:[[response.request URL] absoluteString]
//                                                               serverResponseTime:serverTime * 1000
//                                                                     responseCode:code];
//    [AIFPerformanceReporter reportWithModel:model];
//}

#pragma mark - Cancel requests
- (void)cancelRequest:(FFRequestID)requestID
{
    [[FFApiManager shareInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)cancelRequestsWithTarget:(id)target
{
    
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSOperation *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (void)cancelAllRequest
{
    if (self.dispatchTable.allKeys.count > 0) {
        for (NSNumber *requestId in self.dispatchTable.allKeys) {
            [self cancelRequestWithRequestID:requestId];
        }
    }
}

- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

@end
