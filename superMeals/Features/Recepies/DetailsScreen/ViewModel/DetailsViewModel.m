//
//  DetailsViewModel.m
//  superMeals
//
//  Created by Vitor Spessoto on 05/05/22.
//

#import <Foundation/Foundation.h>
#import "DetailsViewModel.h"

@implementation DetailsViewModel : NSObject

- (void)downloadMainImageFor:(SMRecepies *)recepie completionHandler:(void (^)(UIImage * _Nullable image))completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSURL *url = [NSURL URLWithString:recepie.main.primaryPictureURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *recepieImage = [UIImage imageWithData:imageData];
        completionHandler(recepieImage);
    });
}

- (void)downloadMainImage:(void (^_Nonnull)(UIImage * _Nullable image))completionHandler {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSURL *url = [NSURL URLWithString:self->_recepies.main.primaryPictureURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *recepieImage = [UIImage imageWithData:imageData];
        completionHandler(recepieImage);
    });
}

@end
