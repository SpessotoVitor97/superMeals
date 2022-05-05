//
//  SMRecepiesViewModelDelegate.h
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#import <Foundation/Foundation.h>
#import "SMRecepies.h"

@protocol SMRecepiesViewModelDelegate <NSObject>

@required
- (void)onSuccess;
- (void)onError:(NSError *)error;

@end
