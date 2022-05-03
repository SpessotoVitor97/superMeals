//
//  ViewController.m
//  superMeals
//
//  Created by Vitor Spessoto on 29/04/22.
//

#import "ViewController.h"

@interface ViewController () <SMRecepiesViewModelDelegate>

@end

@implementation ViewController

NSString *recepie1 = @"http://emeals-menubuilder-public.s3.amazonaws.com/v1/recipes/46168/46168_295947.json";
NSString *recepie2 = @"http://emeals-menubuilder-public.s3.amazonaws.com/v1/recipes/37767/37767_241270.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewModel];
}

- (void)setupViewModel {
    self.viewModel = [[SMRecepiesViewModel alloc] init];
    _viewModel.delegate = self;
    
    [self fetchRecepies];
}

- (void)fetchRecepies {
    [[self viewModel] fetchRecepiesFrom:recepie1];
}

- (void)onSuccess:(SMRecepies *)recepies {
    NSLog(@"%@", recepies);
}

- (void)onError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
