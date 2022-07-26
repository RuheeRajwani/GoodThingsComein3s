//
//  HomeViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import "AFNetworking.h"
#import "HomeViewController.h"
#import "PriceFilterViewController.h"
#import "APIManager.h"
#import "RestaurantTableViewCell.h"

@interface HomeViewController () <PriceFilterViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeRestaurantTableView;
@property (nonatomic) NSArray *restaurantArray;
@property (nonatomic) NSString *priceFilters;
@property (nonatomic) NSString *categories;
@property (nonatomic) NSInteger *radius;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;




@end

@implementation HomeViewController
- (IBAction)homeViewControllerDidTapGenerate:(id)sender {
    self.homeRestaurantTableView.hidden = YES;
    [self fetchRestaurants];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchRestaurants) forControlEvents:UIControlEventValueChanged];
    [self.homeRestaurantTableView insertSubview:self.refreshControl atIndex:0];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeRestaurantTableView.dataSource = self;
    self.homeRestaurantTableView.delegate = self;
    self.homeRestaurantTableView.hidden = YES;
    self.activityIndicator.hidden =YES;
    
}

-(void) fetchRestaurants{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [[APIManager shared] getGeneratedRestaurants:@"Seattle" price:self.priceFilters categories:self.categories radius:0 completion:^(NSArray * _Nonnull restaurants, NSError * _Nonnull error) {
        if(restaurants){
            self.restaurantArray = (NSMutableArray*) restaurants;
            NSLog(@"Successfully loaded array");
        } else{
            NSLog(@"Error loading restaurants");
        }
        [self.homeRestaurantTableView reloadData];
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
        self.homeRestaurantTableView.hidden = NO;
    }];
    }
        
    



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantTableViewCell" forIndexPath:indexPath];
    cell.restaurant = self.restaurantArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"HomeToPriceFilterSegue"]) {
        PriceFilterViewController *priceFilterVC = [segue destinationViewController];
        priceFilterVC.delegate= self;
    }
    
}

- (void)appliedPriceFilters:(NSString *)priceStringToSend {
    self.priceFilters = priceStringToSend;
}

@end
