//
//  DetailsViewController.m
//  superMeals
//
//  Created by Vitor Spessoto on 04/05/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *mainInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *recepieImageView;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;

@property (weak, nonatomic) IBOutlet UIView *cookInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *timerImageView;
@property (weak, nonatomic) IBOutlet UIStackView *infoStackView;
@property (weak, nonatomic) IBOutlet UILabel *prepLabel;
@property (weak, nonatomic) IBOutlet UILabel *cookLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet UIView *mainDishView;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (weak, nonatomic) IBOutlet UIView *sideDishView;
@property (weak, nonatomic) IBOutlet UILabel *sideDishIngredientsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sideDishIngredientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sideDishInstructionsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sideDishInstructionsLabel;

@end

@implementation DetailsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setsBackgroundColorToNormal];
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] navigationBar].backgroundColor = [UIColor systemGreenColor];
}

#pragma mark - Private methods
- (void)setsBackgroundColorToNormal {
    [_scrollView setBackgroundColor:UIColor.systemGreenColor];
    [_contentView setBackgroundColor:UIColor.systemGreenColor];
    [_mainInfoView setBackgroundColor:UIColor.systemGreenColor];
    [_titleView setBackgroundColor:UIColor.systemIndigoColor];
    [_cookInfoView setBackgroundColor:UIColor.systemBackgroundColor];
    [_separatorView setBackgroundColor:UIColor.systemBackgroundColor];
    [_mainDishView setBackgroundColor:UIColor.systemBackgroundColor];
    [_sideDishView setBackgroundColor:UIColor.systemGray6Color];
}

- (void)configureUI {
    SMRecepies *recepies = _viewModel.recepies;
    long totalTime = recepies.main.prepTime + recepies.main.cookTime;
    
    [self downloadImage:recepies.main.primaryPictureURL];
    _recepieImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainTitle.text = recepies.main.title;
    _infoStackView.distribution = UIStackViewDistributionFillProportionally;
    _infoStackView.spacing = 8;
    _prepLabel.text = [NSString stringWithFormat:@"%ld%@", (long)recepies.main.prepTime, @"m Prep"];
    _cookLabel.text = [NSString stringWithFormat:@"%ld%@", (long)recepies.main.cookTime, @"m Cook"];
    _totalLabel.text = [NSString stringWithFormat:@"%ld%@", (long)totalTime, @"m total"];
    _ingredientsTitleLabel.text = @"Ingredients";
    _ingredientsLabel.numberOfLines = 0;
    _ingredientsLabel.text = [self convertToStr:recepies.main.ingredients];
    _instructionsTitleLabel.text = @"Instructions";
    _instructionsLabel.numberOfLines = 0;
    _instructionsLabel.text = [self convertToStr:recepies.main.instructions];
    _sideDishIngredientsTitleLabel.text = @"Ingredients";
    _sideDishIngredientsLabel.numberOfLines = 0;
    _sideDishIngredientsLabel.text = [self convertToStr:recepies.side.ingredients];
    _sideDishInstructionsTitleLabel.text = @"Instructions";
    _sideDishInstructionsLabel.numberOfLines = 0;
    _sideDishInstructionsLabel.text = [self convertToStr:recepies.side.instructions];
}

- (void)downloadImage:(NSString *)urlString {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *recepieImage = [UIImage imageWithData:imageData];

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self->_recepieImageView.image = recepieImage;
        });
    });
}

- (NSString *)convertToStr:(NSDictionary *)dictionary {
    NSString *str = @"";
    NSString *lineJumper = @"\n";
    
    for (id key in dictionary) {
        id value = dictionary[key];

        if ([str isEqualToString:@""]) {
            str = value;
        } else {
            [str stringByAppendingString:lineJumper];
            [str stringByAppendingString:value];
        }

        NSLog(@"%@", str);
    }

    NSLog(@"%@", str);
    return str;
}

@end
