//
//  XJNetWorkManager.m
//  XJNetWorkManager-Example
//
//  Created by 江鑫 on 2018/5/11.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import "XJNetWorkManager.h"
#import "XJHttpManager.h"

@implementation XJNetWorkManager

+ (XJBaseRequest*) xj_GETRequestWithURL:(NSString*)url parameter:(id)parameter successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;
{
    
   return  [self xj_RequestWithURL:url parameter:parameter timeoutInterval:0 method:XJRequestMethodGET successBlock:successblock failBlock:failblock];
  
}

+ (XJBaseRequest*) xj_PostRequestWithURL:(NSString*)url parameter:(id)parameter successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;
{
    
   return  [self xj_RequestWithURL:url parameter:parameter timeoutInterval:0 method:XJRequestMethodPOST successBlock:successblock failBlock:failblock];
    
}

+ (XJBaseRequest*) xj_RequestMethod:(XJRequestMethod)method url:(NSString*)url parameter:(id)parameter  successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;
{
   return [self xj_RequestWithURL:url parameter:parameter timeoutInterval:0 method:method successBlock:successblock failBlock:failblock];
}

+ (XJBaseRequest*) xj_GETRequestWithURL:(NSString*)url parameter:(id)parameter timeoutInterval:(CGFloat)timeoutSecond successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;
{
  return  [self xj_RequestWithURL:url parameter:parameter timeoutInterval:timeoutSecond method:XJRequestMethodGET successBlock:successblock failBlock:failblock];
}

+ (XJBaseRequest*) xj_PostRequestWithURL:(NSString*)url parameter:(id)parameter timeoutInterval:(CGFloat)timeoutSecond successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;
{
    
   return [self xj_RequestWithURL:url parameter:parameter timeoutInterval:timeoutSecond method:XJRequestMethodPOST successBlock:successblock failBlock:failblock];
    
}


+ (XJBaseRequest*) xj_RequestWithURL:(NSString*)url parameter:(id)parameter timeoutInterval:(CGFloat)timeoutSecond method:(XJRequestMethod)method successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock
{
    XJBaseRequest *baseRequest = [[XJBaseRequest alloc]init];
    
    baseRequest.api = url;
    baseRequest.params = parameter;
    if (timeoutSecond == 0)baseRequest.timeoutInterval = timeoutSecond;
    baseRequest.requestmethod = method;
    
    [[XJHttpManager shareManager]configBaseRequest:baseRequest completionSuccessblock:^(id response) {
        
        
        
        
    } completionFailblock:^(NSError *error,NSString*msg) {
        
    }];
    
    return baseRequest;
    
    
}


- (void) xj_uploadImageArray:(NSArray*)dataArray url:(NSString*)url parameter:(id)parameter;
{
    
    XJBaseRequest *baseRequest = [[XJBaseRequest alloc]init];
    
    baseRequest.api = url;
    baseRequest.params = parameter;

   
    
    
}


- (void) cancleAllRequest;
{
    return [[XJHttpManager shareManager]cancleAllRequest];
}

- (NSArray<NSURLSessionTask*>*) allCurrentSessionTaskRequest;
{
    return [[XJHttpManager shareManager]allCurrentSessionTaskRequest];
}

- (NSArray<NSString*>*) allCurrentURLRequest;
{
    return [[XJHttpManager shareManager]allCurrentURLRequest];
}

- (NSArray<XJBaseRequest*>*) allCurrentBaseRequest;
{
    return [[XJHttpManager shareManager]allCurrentBaseRequest];
}

@end
