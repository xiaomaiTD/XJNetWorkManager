//
//  XJHttpManager.m
//  XJNetWorkManager-Example
//
//  Created by 江鑫 on 2018/5/12.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import "XJHttpManager.h"
#import "AFNetworking.h"


@interface XJHttpManager()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, copy)  NSString *baseUrl;

@property (nonatomic, copy)  NSString *apiErrorUrl;

@property (nonatomic, assign) BOOL isShowRequestLog;

@property (nonatomic, assign) BOOL isUploadErrorAPI;

@property (nonatomic, strong) NSMutableArray<XJBaseRequest *> * allRequestArray;

@end

@implementation XJHttpManager

+ (XJHttpManager*)shareManager
{
    
    static XJHttpManager *sharemanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharemanager) {
            
            sharemanager = [[XJHttpManager alloc]init];
            
        }
    });
    return sharemanager;
    
}

- (id) init
{
    self = [super init];
    if (self) {
        
        //待优化,可依据库外配置,暂时写死:
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 30.f;//默认时间;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"application/x-www-form-urlencoded", @"image/*", nil];
        _manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
       
    }
    
    return self;
    
    
}

- (void) configBaseURL:(NSString*)URL isShowRequestLog:(BOOL)showlog uploadErrorAPI:(BOOL)isUpload httpDlegate:(id)delegate;
{
    
    self.baseUrl = URL;
    
    self.isShowRequestLog = showlog;
    
    self.isUploadErrorAPI = isUpload;
    
}

- (void) configBaseRequest:(XJBaseRequest*)request completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;
{

    [self logapi:request.api param:request.params];
    
    request.requestURL = [NSString stringWithFormat:@"%@%@",self.baseUrl,request.api];
    
    switch (request.requestmethod) {
        case XJRequestMethodGET:
        {
            
            request.requestTask = [self.manager GET:request.requestURL parameters:request.params progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleResponseTask:task isSuccess:YES baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failblock)failblock(error,nil);
                [self handleResponseTask:task isSuccess:YES baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:nil];
                
            }];
        }
            break;
        case XJRequestMethodPOST:
        {
            request.requestTask = [self.manager POST:request.requestURL parameters:request.params progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleResponseTask:task isSuccess:YES baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            if(failblock)failblock(error,nil);
                [self handleResponseTask:task isSuccess:YES baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:nil];
                
            }];
        }
            break;
        case XJRequestMethodDELETE:
        {
            request.requestTask = [self.manager DELETE:request.requestURL parameters:request.params  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleResponseTask:task isSuccess:YES baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            if(failblock)failblock(error,error.localizedDescription);
                [self handleResponseTask:task isSuccess:YES baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:nil];
                
            }];
        }
            break;
        case XJRequestMethodHEAD:
        {
            request.requestTask = [self.manager HEAD:request.requestURL parameters:request.params success:^(NSURLSessionDataTask * _Nonnull task) {
                
               [self handleResponseTask:task isSuccess:YES baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:nil];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failblock)failblock(error,nil);
                [self handleResponseTask:task isSuccess:NO baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:nil];
                
            }];
            

        }
            break;
        case XJRequestMethodPUT:
        {
            request.requestTask = [self.manager PUT:request.requestURL parameters:request.params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleResponseTask:task isSuccess:YES baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failblock)failblock(error,error.localizedDescription);
                [self handleResponseTask:task isSuccess:NO baseRequest:request SuccessBlock:successBlock completionFailblock:failblock response:nil];
                
            }];
        }
            break;
        default:
            break;
    }
    
    
    [self.allRequestArray addObject:request];
    
    
}


- (void) handleResponseTask:(NSURLSessionTask*)task isSuccess:(BOOL)isSuccess baseRequest:(XJBaseRequest*)request SuccessBlock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock response:(id)responseObject;
{
    
    
    if (isSuccess) {

        
        NSError *dataError;
        NSObject *resultObecjt = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&dataError];
        
        if (!dataError) {
            
           NSError *resultError  = [self validateResponseObjectFormat:resultObecjt];
            if (resultError) {
                if (failblock) failblock(resultError,resultError.localizedDescription);
                return;
            }else{
               if (successBlock)successBlock(resultObecjt);
               return;
            }
            
        }else{
            
            //返回数据格式无法解析:
            NSDictionary * userInfo = [NSDictionary dictionaryWithObject:@"返回数据异常,无法解析" forKey:NSLocalizedDescriptionKey];
            NSError * aError = [NSError errorWithDomain:XJRequestErrorDomain code:XJResponseErrorCodeUnkwon userInfo:userInfo];
            failblock(aError,aError.localizedDescription);
            
        }
        [self.allRequestArray removeObject:request];
        
        
    }else{
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        request.response = response;
        request.statsusCode = response.statusCode;
        
        //非上报API错误,需要将错误上报服务器:
        if (![request.api isEqualToString:self.apiErrorUrl]) {
            if (self.isUploadErrorAPI) [self uploadAPIError:request];
        }
        
        [self.allRequestArray removeObject:request];
        
        
    }
    
    
}

- (NSError*)  validateResponseObjectFormat:(id)responseObject
{
    
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *jsondic = (NSDictionary *)responseObject;
        NSString *result = jsondic[@"result"];
        if (result.integerValue == 1) {
            
            return nil;
            
        }else{
            
            NSDictionary *errorDic = jsondic[@"error"];
            NSString *msg = errorDic[@"msg"];
            NSInteger errorNum = [errorDic[@"code"]integerValue];
            NSDictionary * userInfo = [NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey];
            NSError * aError = [NSError errorWithDomain:XJRequestErrorDomain code:errorNum userInfo:userInfo];
            return aError;
            
        }
        
    }
    
    return nil;
    
}

- (NSString*) httpMethodTransform:(XJRequestMethod)method
{
    switch (method) {
        case XJRequestMethodPOST:
            return @"POST";
            break;
        case XJRequestMethodGET:
            return @"GET";
            break;
        case XJRequestMethodHEAD:
            return @"HEAD";
            break;
        case XJRequestMethodPUT:
            return @"PUT";
            break;
        case XJRequestMethodDELETE:
            return @"DELETE";
            break;
        default:
            break;
    }
    
}



/**同步上传多图片:
*该方式不能获取具体上传到哪一张图片,以及每张图片的上传进度,只能知道上传的总进度额;
 而且上传过程中失败后需重新开始上传;
 */
- (void) xj_uploadImageArray:(XJBaseRequest*)request progressBlock:(XJSynUploadImagesBlock)progressBlock completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;
{
    
    request.requestURL = [NSString stringWithFormat:@"%@%@",self.baseUrl,request.api];
    
    [self.manager POST:request.requestURL parameters:request.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSData*imagedata in request.uploadImageArray) {
            
            [formData appendPartWithFileData:imagedata name:[NSString stringWithFormat:@"xjimage-%ld",[request.uploadImageArray indexOfObject:imagedata]] fileName:@"file" mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //回到主线程,以便外部直接刷新UI:
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (progressBlock) {
                
                progressBlock(uploadProgress.fractionCompleted);
                
            }
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    [self.allRequestArray addObject:request];
    
}






//总进度,上传到哪张图片了,上传那张图片的进度;
- (void) xj_synUploadImageArrayDetail:(XJBaseRequest*)request uploadIndexProgress:(XJSynUploadImagesDetailProgressBlock)progressblock completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;
{
    
    if (!request.requestURL) {
        request.requestURL = [NSString stringWithFormat:@"%@%@",self.baseUrl,request.api];
    }

    if (!request.totalUploadDataLength) {
        for (NSData*data in request.uploadImageArray) {
            request.totalUploadDataLength += data.length;
        }
    }
    
    [self.manager POST:request.requestURL parameters:request.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData*imagedata = request.uploadImageArray[request.currentUploadIndex];
            
        [formData appendPartWithFileData:imagedata name:[NSString stringWithFormat:@"xjimage-%ld",request.currentUploadIndex] fileName:@"file" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //回到主线程,以便外部直接刷新UI:
        dispatch_async(dispatch_get_main_queue(), ^{
            
         CGFloat currentProgress = uploadProgress.fractionCompleted;
         
         request.currentUploadLength += uploadProgress.completedUnitCount;
    progressblock(request.currentUploadIndex,currentProgress,request.currentUploadLength/request.totalUploadDataLength);
            
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        request.currentUploadIndex +=1;
        
        if (request.currentUploadIndex == request.uploadImageArray.count) {
            
            if (successBlock) successBlock(responseObject);
            
            //调用成功的block:
            [self.allRequestArray removeObject:request];
            
        }else{
            
          [self xj_synUploadImageArrayDetail:request uploadIndexProgress:progressblock completionSuccessblock:successBlock completionFailblock:failblock];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        if (failblock) {
//            failblock(error);
//        }
//        
    }];
    
    if (request.currentUploadIndex == 0) {
        [self.allRequestArray addObject:request];
    }
    
    
}


- (void) xj_asyUploadImageArray:(XJBaseRequest*)request;
{
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (NSData*data in request.uploadImageArray) {
        
        dispatch_group_async(group, queue, ^{
            
        });
        
    }
    
    dispatch_group_notify(group, queue, ^{
        
    });
    
}

- (void) xj_uploadImage:(XJBaseRequest*)request progressBlock:(XJUploadImageSingleBlock)progressBlock completionSuccessblock:(XJSuccessCompletionBlock)successBlock completionFailblock:(XJFailCompletionBlock)failblock;
{
    if (!request.requestURL) {
        request.requestURL = [NSString stringWithFormat:@"%@%@",self.baseUrl,request.api];
    }
    
    [self.manager POST:request.requestURL parameters:request.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData*imagedata = request.uploadImageArray[request.currentUploadIndex];
        
        [formData appendPartWithFileData:imagedata name:[NSString stringWithFormat:@"xjimage-%ld",request.currentUploadIndex] fileName:@"file" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //回到主线程,以便外部直接刷新UI:
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        if (failblock) {
//            failblock(error);
//        }
        
    }];
    
   
    [self.allRequestArray addObject:request];
    
    
}


- (void) uploadAPIError:(XJBaseRequest*)request
{
    
    id params = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadAPIError:statusCode:params:response:)]) {
        
       params =  [self.delegate uploadAPIError:request.api statusCode:request.statsusCode params:request.params response:request.response];
        
    }
    
    XJBaseRequest *errorRequest = [[XJBaseRequest alloc]init];
    errorRequest.api = self.apiErrorUrl;
    errorRequest.requestmethod = XJRequestMethodPOST;
    errorRequest.params = params;
    [self configBaseRequest:errorRequest completionSuccessblock:nil completionFailblock:nil];
    
    
}


- (void) logapi:(NSString *)privateUrl param:(NSDictionary *)dic
{
    
    if (self.isShowRequestLog) {
        
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSMutableArray  *arr = [NSMutableArray new];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *keystr = [NSString stringWithFormat:@"%@=%@",key,obj];
            [arr addObject:keystr];
        }];
        NSString *allstr = [arr componentsJoinedByString:@"&"];
        
        NSString *URLString = [NSString stringWithFormat:@"%@%@", self.baseUrl, privateUrl];
        
        if ([privateUrl containsString:@"http://"] || [privateUrl containsString:@"https://"])
        {
            URLString = privateUrl;
        }
        NSLog(@"ALLAPI:%@?%@",URLString,allstr);
        
            
    });
        
    }
    
}


- (void) cancleAllRequest;
{
    
    @synchronized(self){
        
        [self.allRequestArray enumerateObjectsUsingBlock:^(XJBaseRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            [request.requestTask cancel];
            
        }];
        
    }
    
    
}

- (NSArray<NSURLSessionTask*>*) allCurrentSessionTaskRequest;
{
    
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.allRequestArray enumerateObjectsUsingBlock:^(XJBaseRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tempArray addObject:request.requestTask];
        
    }];
    
    return tempArray;
    
}

- (NSArray<NSString*>*) allCurrentURLRequest;
{
    
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.allRequestArray enumerateObjectsUsingBlock:^(XJBaseRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tempArray addObject:request.api];
        
    }];
    
    return tempArray;
    
    
}

- (NSArray<XJBaseRequest*>*) allCurrentBaseRequest;
{
    
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.allRequestArray enumerateObjectsUsingBlock:^(XJBaseRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tempArray addObject:request];
    }];
    
    return tempArray;
    
}

//- (AFHTTPSessionManager*) manager
//{
//    if (!_manager) {
//        _manager = [AFHTTPSessionManager manager];
//    }
//    return _manager;
//}

- (NSMutableArray<XJBaseRequest *> *)allRequestArray
{
    if (!_allRequestArray) {
        
        _allRequestArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _allRequestArray;
}
@end
