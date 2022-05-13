//
//  DetailsViewModel.h
//  superMeals
//
//  Created by Vitor Spessoto on 05/05/22.
//

#ifndef DetailsViewModel_h
#define DetailsViewModel_h

#import <UIKit/UIKit.h>
#import "DetailsViewModelDelegate.h"
#import "SMRecepies.h"

@interface DetailsViewModel : NSObject

@property (weak, nonatomic, nullable) id<DetailsViewModelDelegate> delegate;
@property (strong, nonatomic, nullable) SMRecepies *recepies;

- (void)downloadImage:(NSString *_Nonnull)urlString;

@end

#endif /* DetailsViewModel_h */
