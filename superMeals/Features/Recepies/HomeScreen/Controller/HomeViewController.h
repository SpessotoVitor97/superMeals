//
//  HomeViewController.h
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

#import <UIKit/UIKit.h>
#import "SMRecepiesViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (strong, nonatomic, readwrite) SMRecepiesViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END

