//
//  HTTPMethod.m
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

#import "HTTPMethod.h"

NSString *HTTPMethodString(HTTPMethod method) {
    switch (method) {
        case GET:
            return @"GET";
        case POST:
            return @"POST";
        case PUT:
            return @"PUT";
        case DELETE:
            return @"DELETE";
        case HEAD:
            return @"HEAD";
        default:
             return nil;
    }
}
