//
//  SMRecepiesViewModel.h
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#ifndef SMRecepiesViewModel_h
#define SMRecepiesViewModel_h

#import "SMRecepiesViewModelDelegate.h"

@interface SMRecepiesViewModel : NSObject

@property (weak, nonatomic, nullable) id<SMRecepiesViewModelDelegate> delegate;
@property (strong, nonatomic, nullable) NSMutableArray<SMRecepies*> *recepiesArray;

- (void)fetchRecepies;
- (NSInteger)getTotalRecepies;

@end

#endif /* SMRecepiesViewModel_h */
