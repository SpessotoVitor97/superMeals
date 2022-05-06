//
//  SMRecepiesViewModelDelegate.h
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRecepiesViewModelDelegate <NSObject>

@required
- (void)onSuccess;
- (void)onError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
