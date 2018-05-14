//
//  XJBaseRequest.h
//  XJNetWorkManager-Example
//
//  Created by 江鑫 on 2018/5/11.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XJNewWorkHeader.h"

//循环引用问题:
//#import "XJNetWorkManager.h"

typedef NS_ENUM(NSInteger,XJRequestMethod)
{
    XJRequestMethodGET,
    XJRequestMethodPOST,
    XJRequestMethodPUT,
    XJRequestMethodDELETE,
    XJRequestMethodHEAD,
};

typedef void(^XJSuccessCompletionBlock)(id response);

typedef void(^XJFailCompletionBlock)(NSError* error,NSString*errormsg);

typedef void(^XJUploadImageSingleBlock)(CGFloat progress);

typedef void(^XJSynUploadImagesBlock)(CGFloat progress);

//多图片上传block: 上传到第几张、正在上传的那张的进度、上传的总进度:
typedef void(^XJSynUploadImagesDetailProgressBlock)(NSInteger index, CGFloat progress,CGFloat totalProgress);


@class  XJNetWorkManager;

@interface XJBaseRequest : NSObject

@property (nonatomic, assign) XJRequestMethod requestmethod;

@property (nonatomic, copy) NSString* api;

@property (nonatomic, copy) NSString* requestURL;

@property (nonatomic, strong) id params;

@property (nonatomic, assign) NSInteger statsusCode;

/*********当前正在上传图片的索引********/
@property (nonatomic, assign) NSInteger currentUploadIndex;

@property (nonatomic, strong) NSURLSessionTask *requestTask;

@property (nonatomic, assign) CGFloat timeoutInterval;

@property (nonatomic, strong) id response;

@property (nonatomic, assign) NSInteger totalUploadDataLength;

@property (nonatomic, assign) NSInteger currentUploadLength;

@property (nonatomic, strong) NSMutableArray *uploadImageArray;

@property (nonatomic, copy) XJSuccessCompletionBlock successBlock;

@property (nonatomic, copy) XJFailCompletionBlock failBlock;



- (void) sendHttpRequstSuccessBlock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;

- (void) cancleRequest;

- (void) reUploadImagesUploadIndexProgress:(XJSynUploadImagesDetailProgressBlock)progressblock completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;

@end
