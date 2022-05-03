//
//  SMRecepiesViewModel.m
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#import <Foundation/Foundation.h>
#import "SMRecepiesViewModel.h"

@implementation SMRecepiesViewModel : NSObject

- (void)fetchRecepiesFrom: (NSString *)url {
    [self getDataFrom:url];
}

- (void)getDataFrom:(NSString *)url {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *myRecepies = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Data received: %@", myRecepies);
        NSLog(@"Response received: %@", response);
        NSLog(@"error received: %@", error);
        
        NSError *parseError;
        self.recepies = [SMRecepies fromJSON:myRecepies encoding:NSUTF8StringEncoding error:&parseError];
        [self->_delegate onSuccess:self->_recepies];
    }] resume];
}

@end
