//
//  XJNetWorkManager.h
//  XJNetWorkManager-Example
//
//  Created by 江鑫 on 2018/5/11.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJBaseRequest.h"
#import <UIKit/UIKit.h>


@interface XJNetWorkManager : NSObject

typedef void(^XJSuccessBlock)(id response);
typedef void(^XJFailBlock)(NSString* failMessage);


/**
 Creates and runs an `XJBaseRequest` with a `GET` request.

 @param url 请求url
 @param parameter 请求参数
 @param successblock 请求成功的block回调
 @param failblock 请求失败的block回调
 @return 该url请求对象
 */
+ (XJBaseRequest*) xj_GETRequestWithURL:(NSString*)url parameter:(id)parameter successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;


/**
 Creates and runs an `XJBaseRequest` with a `POST` request.
 
 @param url 请求url
 @param parameter 请求参数
 @param successblock 请求成功的block回调
 @param failblock 请求失败的block回调
 @return 该url请求对象
 */
+ (XJBaseRequest*) xj_PostRequestWithURL:(NSString*)url parameter:(id)parameter successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;


/**
 Creates and runs an `XJBaseRequest` with a optional request.
 
 @param method 请求方式:GET,PUT,POST,HEAD,DELETE
 @param url 请求url
 @param parameter 请求参数
 @param successblock 请求成功的block回调
 @param failblock 请求失败的block回调
 @return 该url请求对象
 */
+ (XJBaseRequest*) xj_RequestMethod:(XJRequestMethod)method url:(NSString*)url parameter:(id)parameter  successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;


/**
 Creates and runs an `XJBaseRequest` with a 'GET' request.
 
 @param url 请求url
 @param parameter 请求参数
 @param timeoutSecond 请求超时时间
 @param successblock 请求成功的block回调
 @param failblock 请求失败的block回调
 @return 该url请求对象
 */
+ (XJBaseRequest*) xj_GETRequestWithURL:(NSString*)url parameter:(id)parameter timeoutInterval:(CGFloat)timeoutSecond successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;


/**
 Creates and runs an `XJBaseRequest` with a 'POST' request.
 
 @param url 请求url
 @param parameter 请求参数
 @param timeoutSecond 请求超时时间
 @param successblock 请求成功的block回调
 @param failblock 请求失败的block回调
 @return 该url请求对象
 */
+ (XJBaseRequest*) xj_PostRequestWithURL:(NSString*)url parameter:(id)parameter timeoutInterval:(CGFloat)timeoutSecond successBlock:(XJSuccessBlock)successblock failBlock:(XJFailBlock)failblock;



/*********上传图片************/

- (void) xj_uploadImageArray:(NSArray*)dataArray url:(NSString*)url parameter:(id)parameter;

- (void) cancleAllRequest;

- (NSArray<NSURLSessionTask*>*) allCurrentSessionTaskRequest;

- (NSArray<NSString*>*) allCurrentURLRequest;

- (NSArray<XJBaseRequest*>*) allCurrentBaseRequest;

@end
