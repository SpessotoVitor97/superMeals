//
//  APIClient.h
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

@import Foundation;

#import "APIRequest.h"
#import "APIResponse.h"

typedef void(^APIClientCompletionBlock)(id<APIResponse> response);

@protocol APIClient <NSObject>

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(id<APIRequest>)request
                                      completion:(APIClientCompletionBlock)completion;

@end

@interface NSURLSession(APIClient) <APIClient>

@end
