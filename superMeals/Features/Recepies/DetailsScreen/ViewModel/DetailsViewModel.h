//
//  DetailsViewModel.h
//  superMeals
//
//  Created by Vitor Spessoto on 05/05/22.
//

#ifndef DetailsViewModel_h
#define DetailsViewModel_h

#import <UIKit/UIKit.h>
#import "SMRecepies.h"

@interface DetailsViewModel : NSObject

@property (strong, nonatomic, nullable) SMRecepies *recepies;
@property (strong, nonatomic, nullable) UIImage *image;
//@property (strong, nonatomic, nullable) NSMutableDictionary<NSString*, UIImage*> *images;
//
//- (void)downloadMainImageFor:(SMRecepies *_Nonnull)recepie completionHandler:(void (^_Nonnull)(UIImage * _Nullable image))completionHandler;
//- (void)downloadMainImage:(void (^_Nonnull)(UIImage * _Nullable image))completionHandler;

@end

#endif /* DetailsViewModel_h */
