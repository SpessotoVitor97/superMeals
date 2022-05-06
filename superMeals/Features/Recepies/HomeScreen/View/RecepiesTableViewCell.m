//
//  RecepiesTableViewCell.m
//  superMeals
//
//  Created by Vitor Spessoto on 03/05/22.
//

#import "RecepiesTableViewCell.h"

@implementation RecepiesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureLayout {
    [self->_activityIndicator setHidesWhenStopped:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self->_activityIndicator startAnimating];
    });
    
    _recepieImageView.layer.cornerRadius = 15;
    _recepieImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _styleInfoView.backgroundColor = [UIColor clearColor];

    _recepieStyle.textColor = [UIColor whiteColor];
    _recepieStyle.font = [UIFont boldSystemFontOfSize:21];

    _recepieServings.textColor = [UIColor whiteColor];
    _recepieServings.font = [UIFont boldSystemFontOfSize:15];
}

- (void)configureLabelsFor:(SMRecepies *)recepie {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
//        self->_recepieImageView.image = recepieImage;
        self->_recepieStyle.text = recepie.planStyle;
        self->_recepieServings.text = recepie.planSize;
        [self->_activityIndicator stopAnimating];
    });
    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        NSURL *url = [NSURL URLWithString:recepie.main.primaryPictureURL];
//        NSData *imageData = [NSData dataWithContentsOfURL:url];
//        UIImage *recepieImage = [UIImage imageWithData:imageData];
//
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            self->_recepieImageView.image = recepieImage;
//            self->_recepieStyle.text = recepie.planStyle;
//            self->_recepieServings.text = recepie.planSize;
//            [self->_activityIndicator stopAnimating];
//        });
//    });
}

@end
