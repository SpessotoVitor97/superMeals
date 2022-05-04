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

- (NSInteger)getTotalRecepies {
    return [_recepiesArray count];
}

- (void)getDataFrom:(NSString *)url {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSString *strError = error.localizedDescription;
            NSLog(@"error received: %@", strError);
            [self->_delegate onError:error];
        }
        
        if (response) {
            NSString *strResponse = response.description;
            NSLog(@"Response received: %@", strResponse);
        }
        
        if (data) {
            NSError *error;
            SMRecepies *recepies = [SMRecepies fromData:data error:&error];
            if (error == NULL) {
                self->_recepiesArray = [[NSArray alloc] initWithObjects:recepies, nil];
                [self->_delegate onSuccess];
            } else {
                NSLog(@"Ops, something went spectacularly wrong -> \n %@", error);
            }
        }
    }] resume];
}

@end
