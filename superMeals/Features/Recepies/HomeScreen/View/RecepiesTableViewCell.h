//
//  RecepiesTableViewCell.h
//  superMeals
//
//  Created by Vitor Spessoto on 03/05/22.
//

#import <UIKit/UIKit.h>
#import "SMRecepiesContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecepiesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recepieImageView;
@property (weak, nonatomic) IBOutlet UIView *styleInfoView;
@property (weak, nonatomic) IBOutlet UIStackView *styleInfoStackView;
@property (weak, nonatomic) IBOutlet UILabel *recepieStyle;
@property (weak, nonatomic) IBOutlet UILabel *recepieServings;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)configureLabelsFor:(SMRecepiesContainer *)recepie;

@end

NS_ASSUME_NONNULL_END
