//
//  Service.m
//  superMeals
//
//  Created by Vitor Spessoto on 03/05/22.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@implementation Service : NSObject

- (void)call:(NSString *)url successHandler:(void (^)(NSData * _Nullable data))successHandler failureHandler:(void (^)(NSError * _Nullable error))failureHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response) {
            NSString *strResponse = response.description;
            NSLog(@"Response received: /n%@", strResponse);
        }
        
        if (error) {
            NSString *strError = error.localizedDescription;
            NSLog(@"error received: /n%@", strError);
            failureHandler(error);
        }
        
        if (data) {
            successHandler(data);
        }
        
    }] resume];
}

@end
