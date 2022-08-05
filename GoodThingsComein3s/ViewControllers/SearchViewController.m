//
//  SearchViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/21/22.
//

#import "AFNetworking.h"
#import "SearchViewController.h"
#import "RestaurantTableViewCell.h"
#import "APIManager.h"
#import "DetailsViewController.h"
#import "DGActivityIndicatorView.h"


@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation SearchViewController

- (IBAction)searchViewControllerDidTapSearch:(id)sender {
    [self.activityIndicatorView setHidden:NO];
    [self.activityIndicatorView startAnimating];
    
    NSString *searchText = self.searchBar.text;
    [[APIManager shared] getRestaurantSearchResults:@"Seattle" searchTerm:searchText completion:^(NSArray * _Nonnull restaurants, NSError * _Nonnull error) {

        if (restaurants) {
            self.filteredData = restaurants;
            NSLog(@"Successfully loaded array");
            [self.searchTableView reloadData];
        } else {
            NSLog(@"Error loading restaurants");
        }
        [self.activityIndicatorView setHidden:YES];
        [self.activityIndicatorView stopAnimating];
    }];
}

- (IBAction)didTapGestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
    self.filteredData = [[NSArray alloc] init];
    
    self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulseSync tintColor:[UIColor colorWithRed:45/255.0 green:121/255.0 blue:253/255.0 alpha:1.0] size:50.0f];
    self.activityIndicatorView.frame = CGRectMake(self.view.center.x - 25, self.view.center.y - 25, 50.0f, 50.0f);
    [self.view addSubview:self.activityIndicatorView];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([[segue identifier] isEqualToString:@"RestaurantTableViewCellToRestaurantDetailsView"]) {
         NSIndexPath *restaurantIndexPath = [self.searchTableView indexPathForCell:sender];
         DetailsViewController *detailVC = [segue destinationViewController];
         detailVC.restaurantToShow = self.filteredData[restaurantIndexPath.row];
     }
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantTableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:@"RestaurantTableViewCell"
                                                                 forIndexPath:indexPath];
    cell.restaurant = self.filteredData[indexPath.row];
    return cell;
}

@end
