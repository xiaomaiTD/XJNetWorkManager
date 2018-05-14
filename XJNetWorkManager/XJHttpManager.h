//
//  XJHttpManager.h
//  XJNetWorkManager-Example
//
//  Created by 江鑫 on 2018/5/12.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJBaseRequest.h"

typedef NS_ENUM(NSInteger,XJResponseErrorCode)
{
    XJResponseErrorCodeUnkwon = 101,
    XJResponseErrorCodeUnkff = 102,
};

@protocol XJHttpConfigDlegate<NSObject>

- (id) uploadAPIError:(NSString*)api statusCode:(NSInteger)statusCode params:(id)params response:(id)response;

@end

@interface XJHttpManager : NSObject

@property (nonatomic,assign) id<XJHttpConfigDlegate>delegate;

+ (XJHttpManager*)shareManager;

- (void) configBaseURL:(NSString*)URL isShowRequestLog:(BOOL)showlog uploadErrorAPI:(BOOL)isUpload httpDlegate:(id)delegate;

- (void) configBaseRequest:(XJBaseRequest*)request completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;


- (void) xj_uploadImage:(XJBaseRequest*)request progressBlock:(XJUploadImageSingleBlock)progressBlock completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;

- (void) xj_uploadImageArray:(XJBaseRequest*)request progressBlock:(XJSynUploadImagesBlock)progressBlock completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;

- (void) xj_synUploadImageArrayDetail:(XJBaseRequest*)request uploadIndexProgress:(XJSynUploadImagesDetailProgressBlock)progressblock completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;

- (void) xj_asyUploadImageArray:(XJBaseRequest*)request;


- (void) cancleAllRequest;

- (NSArray<NSURLSessionTask*>*) allCurrentSessionTaskRequest;

- (NSArray<NSString*>*) allCurrentURLRequest;

- (NSArray<XJBaseRequest*>*) allCurrentBaseRequest;

@end
