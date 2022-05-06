//
//  SMRecepiesViewModel.h
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#ifndef SMRecepiesViewModel_h
#define SMRecepiesViewModel_h

#import <UIKit/UIKit.h>
#import "SMRecepiesViewModelDelegate.h"
#import "SMRecepies.h"

@interface SMRecepiesViewModel : NSObject

@property (weak, nonatomic, nullable) id<SMRecepiesViewModelDelegate> delegate;
@property (strong, nonatomic, nullable) NSMutableArray<SMRecepies*> *recepiesArray;

- (void)fetchRecepies;
- (NSInteger)getTotalRecepies;
- (void)downloadMainImageFor:(SMRecepies *_Nonnull)recepie completionHandler:(void (^_Nonnull)(UIImage * _Nullable image))completionHandler;

@end

#endif /* SMRecepiesViewModel_h */
