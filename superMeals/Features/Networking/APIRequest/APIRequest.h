//
//  APIRequest.h
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

#import <Foundation/Foundation.h>
#import "HTTPMethod.h"

@protocol APIResponseDelegate;

@protocol APIRequest <NSObject>

- (HTTPMethod)method;
- (NSURL *)baseURL;
- (NSString *)path;
- (NSDictionary *)parameters;
- (NSDictionary *)headers;
- (Class<APIResponseDelegate>)responseClass;

@end

@interface SimpleAPIRequest : NSObject <APIRequest>

@end

@interface JSONAPIRequest : SimpleAPIRequest

@end
