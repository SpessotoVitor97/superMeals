//
//  APIResponse.h
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

@import Foundation;

@protocol APIResponse <NSObject>

- (NSURLSessionDataTask *)task;
- (NSURLResponse *)response;
- (NSError *)error;
- (id)responseObject;
- (id)processedResponseObject;

- (instancetype)initWithTask:(NSURLSessionDataTask *)task
                    response:(NSURLResponse *)response
              responseObject:(id)responseObject
                       error:(NSError *)error;

- (id)processResponseObject:(NSError **)error;

@end

@interface SimpleAPIResponse: NSObject <APIResponse> {
    NSURLSessionDataTask *_task;
    NSURLResponse *_response;
    NSError *_error;
    id _responseObject;
    id _processedResponseObject;
}

@end

@interface JSONAPIResponse : SimpleAPIResponse

@end
