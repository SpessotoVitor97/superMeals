//
//  APIRequest.h
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

@import Foundation;

#import "HTTPMethod.h"

@protocol APIResponse;

@protocol APIRequest <NSObject>

- (HTTPMethod)method;
- (NSURL *)baseURL;
- (NSString *)path;
- (NSDictionary *)parameters;
- (NSDictionary *)headers;
- (Class<APIResponse>)responseClass;

@end

@interface SimpleAPIRequest : NSObject <APIRequest>

@end

@interface JSONAPIRequest : SimpleAPIRequest

@end
