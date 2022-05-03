//
//  ViewController.m
//  superMeals
//
//  Created by Vitor Spessoto on 29/04/22.
//

#import "ViewController.h"
#import "RecepiesViewController.h"

@interface ViewController () <SMRecepiesViewModelDelegate>

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;

@end

@implementation ViewController

#pragma mark - Private constants
NSString *recepie1 = @"http://emeals-menubuilder-public.s3.amazonaws.com/v1/recipes/46168/46168_295947.json";
NSString *recepie2 = @"http://emeals-menubuilder-public.s3.amazonaws.com/v1/recipes/37767/37767_241270.json";

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewModel];
    [self setupUI];
}

#pragma mark - Private methods
- (void)setupViewModel {
    self.viewModel = [[SMRecepiesViewModel alloc] init];
    _viewModel.delegate = self;
    
    [self fetchRecepies];
}

- (void)setupUI {
    self.getStartedButton.layer.cornerRadius = 5;
    self.getStartedButton.clipsToBounds = YES;
}

- (void)fetchRecepies {
    [[self viewModel] fetchRecepiesFrom:recepie1];
}

#pragma mark - IBActions
- (IBAction)getStartedButtonTouched:(UIButton *)sender {
    RecepiesViewController *recepiesViewController = [[RecepiesViewController alloc] init];
    [[self navigationController] pushViewController:recepiesViewController animated:YES];
}

#pragma mark - SMRecepiesViewModelDelegate methods
- (void)onSuccess:(SMRecepies *)recepies {
    NSLog(@"%@", recepies);
}

- (void)onError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
