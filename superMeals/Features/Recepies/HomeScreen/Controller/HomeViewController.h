//
//  HomeViewController.h
//  superMeals
//
//  Created by Vitor Spessoto on 30/04/22.
//

#import <UIKit/UIKit.h>
#import "SMRecepiesViewModel.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic, nonnull) SMRecepiesViewModel *viewModel;

@end

