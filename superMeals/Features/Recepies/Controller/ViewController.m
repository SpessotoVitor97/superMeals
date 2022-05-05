//
//  ViewController.m
//  superMeals
//
//  Created by Vitor Spessoto on 29/04/22.
//

#import "ViewController.h"
#import "RecepiesTableViewCell.h"

@interface ViewController () <SMRecepiesViewModelDelegate, UITableViewDelegate, UITableViewDataSource>

#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UITableView *recepiesTableView;

@end

@implementation ViewController

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

#pragma mark - Private methods
- (void)setupViewModel {
    self.viewModel = [[SMRecepiesViewModel alloc] init];
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


#pragma mark - SMRecepiesViewModelDelegate methods
- (void)onSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_recepiesTableView reloadData];
    });
}

- (void)onError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - UItableViewDelegate and dataSource methods
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = [_viewModel getTotalRecepies];
    return numberOfRowsInSection;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecepiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecepiesCellRestorationID forIndexPath:indexPath];
    [cell configure:[[_viewModel recepiesArray] objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"User did selected this row -> %@", indexPath);
}

@end
