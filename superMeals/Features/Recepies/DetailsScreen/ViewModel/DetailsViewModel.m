//
//  DetailsViewModel.m
//  superMeals
//
//  Created by Vitor Spessoto on 05/05/22.
//

#import <Foundation/Foundation.h>
#import "DetailsViewModel.h"

@implementation DetailsViewModel : NSObject

- (void)downloadImage:(NSString *)urlString {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *recepieImage = [UIImage imageWithData:imageData];
        if (recepieImage) {
            [self->_delegate onSuccess:recepieImage];
        } else {
            [self->_delegate onError:@"Failed to download image"];
        }
    });
}

@end
