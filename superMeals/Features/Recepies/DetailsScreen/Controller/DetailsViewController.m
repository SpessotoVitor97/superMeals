//
//  DetailsViewController.m
//  superMeals
//
//  Created by Vitor Spessoto on 04/05/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController () <DetailsViewModelDelegate>

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
    
    _viewModel.delegate = self;
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

- (void)configureMainTitleLabel:(NSString *)title {
    _mainTitle.text = title;
    _mainTitle.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClicked)];
    tapGesture.numberOfTapsRequired = 1;
    [_mainTitle addGestureRecognizer:tapGesture];
}

- (void)configureUI {
    SMRecepies *recepies = _viewModel.recepies;
    long totalTime = recepies.main.prepTime + recepies.main.cookTime;
    
    [_viewModel downloadImage:recepies.main.primaryPictureURL];
    [self configureMainTitleLabel:recepies.main.title];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self->_recepieImageView.contentMode = UIViewContentModeScaleAspectFill;
        self->_infoStackView.distribution = UIStackViewDistributionFillProportionally;
        self->_infoStackView.spacing = 8;
        self->_prepLabel.text = [NSString stringWithFormat:@"%ld%@", (long)recepies.main.prepTime, @"m Prep"];
        self->_cookLabel.text = [NSString stringWithFormat:@"%ld%@", (long)recepies.main.cookTime, @"m Cook"];
        self->_totalLabel.text = [NSString stringWithFormat:@"%ld%@", (long)totalTime, @"m total"];
        self->_ingredientsTitleLabel.text = @"Ingredients";
        self->_ingredientsLabel.numberOfLines = 0;
        self->_ingredientsLabel.text = [self convertToStr:recepies.main.ingredients];
        self->_instructionsTitleLabel.text = @"Instructions";
        self->_instructionsLabel.numberOfLines = 0;
        self->_instructionsLabel.text = [self convertToStr:recepies.main.instructions];
        self->_sideDishIngredientsTitleLabel.text = @"Ingredients";
        self->_sideDishIngredientsLabel.numberOfLines = 0;
        self->_sideDishIngredientsLabel.text = [self convertToStr:recepies.side.ingredients];
        self->_sideDishInstructionsTitleLabel.text = @"Instructions";
        self->_sideDishInstructionsLabel.numberOfLines = 0;
        self->_sideDishInstructionsLabel.text = [self convertToStr:recepies.side.instructions];
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

#pragma mark - Actions

- (void)updateRecepieTitleTo:(NSString *)newTitle {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self->_mainTitle.text = newTitle;
    });
    _viewModel.recepies.main.title = newTitle;
}

- (void)labelClicked {
    [self displayAlertTextFieldWithTitle:@"Looks like you are trying to rename this recepie" message:@"How would you like us to call it?" actionTitle:@"rename_"];
}

#pragma mark - ViewModel delegate's methods
- (void)onSuccess:(nonnull UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self->_recepieImageView.image = image;
    });
}

- (void)onError:(nonnull NSString *)errorMsg {
    [self displayErrorAlert:errorMsg AlertTitle:@"We are sorry..." actionTitle:@"Ok"];
}

- (void)displayAlertTextFieldWithTitle:(NSString *)alertTitle message:(NSString *)message actionTitle:(NSString *)actionTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"New title";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];

    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {

        NSArray * textFields = alertController.textFields;
        UITextField * titleTextField = textFields[0];
        NSLog(@"%@", titleTextField.text);
        [self updateRecepieTitleTo:titleTextField.text];
    }];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)displayErrorAlert:(NSString *)message AlertTitle:(NSString *)alertTitle actionTitle:(NSString *)actionTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:actionTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
