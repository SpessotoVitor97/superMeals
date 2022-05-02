//
//  HTTPMethod.h
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

#ifndef HTTPMETHOD_H_
#define HTTPMETHOD_H_

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HTTPMethod){
    GET, POST, PUT, DELETE, HEAD
};

extern NSString *HTTPMethodString(HTTPMethod method);

#endif

