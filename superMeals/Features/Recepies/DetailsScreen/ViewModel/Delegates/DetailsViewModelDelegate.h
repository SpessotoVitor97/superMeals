//
//  DetailsViewModelDelegate.h
//  superMeals
//
//  Created by Vitor Spessoto on 12/05/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewModelDelegate <NSObject>

@required
- (void)onSuccess:(UIImage *)image;
- (void)onError:(NSString *)errorMsg;

@end

NS_ASSUME_NONNULL_END
