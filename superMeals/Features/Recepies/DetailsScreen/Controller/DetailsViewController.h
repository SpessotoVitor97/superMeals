//
//  DetailsViewController.h
//  superMeals
//
//  Created by Vitor Spessoto on 04/05/22.
//

#import <UIKit/UIKit.h>
#import "DetailsViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic, nonnull) DetailsViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
