//
//  HomeViewController.m
//  superMeals
//
//  Created by Vitor Spessoto on 29/04/22.
//

#import "HomeViewController.h"
#import "RecepiesTableViewCell.h"
#import "DetailsViewModel.h"
#import "DetailsViewController.h"

@interface HomeViewController () <SMRecepiesViewModelDelegate, UITableViewDelegate, UITableViewDataSource>

#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UITableView *recepiesTableView;

@end

@implementation HomeViewController

#pragma mark - Private constants
NSString *kRecepiesCell = @"RecepiesTableViewCell";
NSString *kRecepiesCellRestorationID = @"RecepiesCell";

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Super Meals";
    
    [self setupTableView];
    [self setupViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] navigationBar].backgroundColor = [UIColor systemBackgroundColor];
}

#pragma mark - Private methods
- (void)setupViewModel {
    _viewModel = [[SMRecepiesViewModel alloc] init];
    _viewModel.delegate = self;
    
    [_viewModel fetchRecepies];
}

- (void)setupTableView {
    UINib *recepieCell = [UINib nibWithNibName:kRecepiesCell bundle:nil];
    [[self recepiesTableView] registerNib:recepieCell forCellReuseIdentifier:kRecepiesCellRestorationID];
    _recepiesTableView.delegate = self;
    _recepiesTableView.dataSource = self;
    _recepiesTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)downloadImage:(RecepiesTableViewCell *)cell recepie:(SMRecepies *)recepie {
    [_viewModel downloadMainImageFor:recepie completionHandler:^(UIImage * _Nullable image) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            cell.recepieImageView.image = image;
            [self->_recepiesTableView reloadData];
        });
    }];
}


#pragma mark - SMRecepiesViewModelDelegate methods
- (void)onSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_recepiesTableView reloadData];
    });
}

- (void)onError:(NSError *)error {
    NSLog(@"%@", error);
    [self displayErrorAlert:error.localizedDescription AlertTitle:@"We are sorry..." actionTitle:@"Ok"];
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

#pragma mark - UItableViewDelegate and dataSource methods
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = [_viewModel getTotalRecepies];
    return numberOfRowsInSection;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecepiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecepiesCellRestorationID forIndexPath:indexPath];
    SMRecepies *recepie = [[_viewModel recepiesArray] objectAtIndex:indexPath.row];
    [self downloadImage:cell recepie:recepie];
    [cell configureLabelsFor:recepie];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMRecepies *recepie = [[_viewModel recepiesArray] objectAtIndex:indexPath.row];
    
    DetailsViewModel *detailsViewModel = [[DetailsViewModel alloc] init];
    detailsViewModel.recepies = recepie;
    
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    detailsViewController.viewModel = detailsViewModel;
    
    [[self navigationController] pushViewController:detailsViewController animated:YES];
}

@end
