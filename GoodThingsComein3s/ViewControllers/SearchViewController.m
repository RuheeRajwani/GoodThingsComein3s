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


@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (IBAction)searchViewControllerDidTapSearch:(id)sender {
    NSString *searchText = self.searchBar.text;
    [[APIManager shared] getRestaurantSearchResults:@"Seattle" searchTerm:searchText completion:^(NSArray * _Nonnull restaurants, NSError * _Nonnull error) {

        if(restaurants){
            self.filteredData = (NSMutableArray*) restaurants;
            NSLog(@"Successfully loaded array");
            [self.searchTableView reloadData];
        } else{
            NSLog(@"Error loading restaurants");
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    self.searchBar.delegate = self;

    
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//
//    self.searchController.obscuresBackgroundDuringPresentation = NO;
//
//    [self.searchController.searchBar sizeToFit];
//    self.searchTableView.tableHeaderView = self.searchController.searchBar;
//
//    self.definesPresentationContext = YES;
    
    self.filteredData = [[NSArray alloc] init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantTableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:@"RestaurantTableViewCell"
                                                                 forIndexPath:indexPath];
    cell.restaurant = self.filteredData[indexPath.row];
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    if (searchText) {
        
    }

}

@end
