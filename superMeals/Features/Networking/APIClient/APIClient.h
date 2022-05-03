//
//  APIClient.h
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"
#import "APIResponseDelegate.h"

typedef void(^APIClientCompletionBlock)(id<APIResponseDelegate> response);

@protocol APIClient <NSObject>

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(id<APIRequest>)request
                                      completion:(APIClientCompletionBlock)completion;

@end

@interface NSURLSession(APIClient) <APIClient>

@end
