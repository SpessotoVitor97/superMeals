//
//  Service.m
//  superMeals
//
//  Created by Vitor Spessoto on 03/05/22.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@implementation Service : NSObject

-(void)makeCall:(NSString *)url {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSString *strError = error.localizedDescription;
            NSLog(@"error received: /n%@", strError);
        }
        
        if (response) {
            NSString *strResponse = response.description;
            NSLog(@"Response received: /n%@", strResponse);
        }
        
        if (data) {
            NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Data received: /n%@", strData);
        }
    }] resume];
}

@end
