//
//  HomeViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import "HomeViewController.h"
#import "APIManager.h"
#import "AFNetworking.h"
#import "RestaurantTableViewCell.h"
#import "SignUpLoginViewController.h"
#import "DetailsViewController.h"
#import "PriceFilterViewController.h"
#import "CuisineFilterViewController.h"
#import "DistanceFilterViewController.h"
#import "RatingFilterViewController.h"

@interface HomeViewController () <PriceFilterViewControllerDelegate, CuisineFilterDelegate, DistanceFilterDelegate, RatingFilterViewControllerDelegate, RestaurantTableViewCellDelegate, SignUpLoginViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *homeRestaurantTableView;
@property (nonatomic) NSArray *restaurantArray;
@property (nonatomic) NSArray *priceFilters;
@property (nonatomic) NSArray *cuisineFilters;
@property (nonatomic) NSArray *ratingFilters;
@property (nonatomic) NSNumber *radius;
@property (weak, nonatomic) IBOutlet UIButton *priceFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *cuisineFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *distanceFilterButton;
@property (nonatomic) NSString *categories;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) Restaurant *restaurantToAddToLikesFollowingLoginSignup;

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
    
    self.priceFilters = [[NSArray alloc] init];
    self.cuisineFilters = [[NSArray alloc] init];
    self.ratingFilters = [[NSArray alloc] init];
}

- (void)fetchRestaurants {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"LiketoSignUpLoginSegue"]) {
        SignUpLoginViewController *signUpLoginVC = [segue destinationViewController];
        signUpLoginVC.delegate= self;
    }
    if ([[segue identifier] isEqualToString:@"RestaurantTableViewCellToRestaurantDetailsView"]) {
        NSIndexPath *restaurantIndexPath = [self.homeRestaurantTableView indexPathForCell:sender];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.restaurantToShow = self.restaurantArray[restaurantIndexPath.row];
    }
    if ([[segue identifier] isEqualToString:@"HomeToCuisineFilterSegue"]) {
        CuisineFilterViewController *cuisineFilterVC = [segue destinationViewController];
        cuisineFilterVC.previouslySelectedCuisineFilters = self.cuisineFilters;
        cuisineFilterVC.delegate= self;
    }
    if ([[segue identifier] isEqualToString:@"HomeToDistanceFilterSegue"]) {
        DistanceFilterViewController *distanceFilterVC = [segue destinationViewController];
        distanceFilterVC.previouslySelectedRadius = self.radius;
        distanceFilterVC.delegate= self;
    }
    if ([[segue identifier] isEqualToString:@"HomeToPriceFilterSegue"]) {
        PriceFilterViewController *priceFilterVC = [segue destinationViewController];
        priceFilterVC.previouslySelectedPriceFilters = self.priceFilters;
        priceFilterVC.delegate= self;
    }
    if ([[segue identifier] isEqualToString:@"HomeToRatingFilterSegue"]) {
        RatingFilterViewController *ratingFilterVC = [segue destinationViewController];
        ratingFilterVC.previouslySelectedRatingFilters = self.ratingFilters;
        ratingFilterVC.delegate= self;
    }
    
}

#pragma mark - Table view
        
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantTableViewCell" forIndexPath:indexPath];
    cell.restaurant = self.restaurantArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - Delegates

- (void)didApplyPriceFilters:(NSArray *)selectedFilters {
    self.priceFilters = selectedFilters;
    if(self.priceFilters.count != 0){
        [self.priceFilterButton setSelected:YES];
    }
}

- (void)didApplyRatingFilters:(nonnull NSArray *)selectedFilters {
    self.ratingFilters = selectedFilters;
    if(self.ratingFilters.count != 0){
        [self.ratingFilterButton setSelected:YES];
    }
}

- (void)didApplyCuisineFilters:(nonnull NSArray *)selectedFilters {
    self.cuisineFilters = selectedFilters;
    if(self.cuisineFilters.count != 0){
        [self.cuisineFilterButton setSelected:YES];
    }
}

- (void)didApplyDistanceFilter:(NSNumber *)radius {
    self.radius = radius;
    if(self.radius != nil) {
        [self.distanceFilterButton setSelected:YES];
    }
}

- (void)addLikedRestaurantToUser: (Restaurant*) restaurant {
    PFUser *currUser = [PFUser currentUser];
    if(currUser != nil) {
        NSMutableArray *likedRestaurants = currUser[@"likedRestaurants"];
        [likedRestaurants addObject: [self _restaurantToParseObject:restaurant]];
        currUser[@"likedRestaurants"]=likedRestaurants;
        [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
          if (succeeded) {
              NSLog(@"Successfully added");
              NSLog(@"%@", currUser[@"likedRestaurants"]);
          } else {
              NSLog(@"Error liking restaurant");
          }
        }];
    } else {
        self.restaurantToAddToLikesFollowingLoginSignup = restaurant;
        [self performSegueWithIdentifier:@"LiketoSignUpLoginSegue" sender:nil];
    }
}

- (PFObject *) _restaurantToParseObject:(Restaurant *) restaurantToConvert {
    PFObject *restaurantToAdd = [[PFObject alloc] initWithClassName:@"Restaurant"];
    restaurantToAdd[@"name"] = restaurantToConvert.name;
    restaurantToAdd[@"restaurantYelpID"] = restaurantToConvert.restaurantYelpID;
    restaurantToAdd[@"price"] = restaurantToConvert.price;
    restaurantToAdd[@"displayAddress"] =  restaurantToConvert.displayAddress;
    restaurantToAdd[@"categories"] = restaurantToConvert.categories;
    restaurantToAdd[@"score"] = restaurantToConvert.score;
    restaurantToAdd[@"ratingValue"] = restaurantToConvert.ratingValue;
    
    NSData *restaurantImageData = UIImagePNGRepresentation(restaurantToConvert.restaurantImage);
    NSString *restaurantImageName = [NSString stringWithFormat:@"%@%@",restaurantToConvert.restaurantYelpID, @"image"];
    restaurantToAdd[@"restaurantImage"] = [PFFileObject fileObjectWithName:restaurantImageName data:restaurantImageData];
    
    NSData *ratingImageData = UIImagePNGRepresentation(restaurantToConvert.ratingImage);
    NSString *ratingImageName = [NSString stringWithFormat:@"%@%@",restaurantToConvert.restaurantYelpID, @"image"];
    restaurantToAdd[@"ratingImage"] = [PFFileObject fileObjectWithName:ratingImageName data:ratingImageData];
    
    return restaurantToAdd;
}

- (void)didTapLikeForRestaurant:(nonnull Restaurant *)restaurant {
    [self addLikedRestaurantToUser:restaurant];
}

- (void)signUpLoginViewControllerDidDismissForUser {
    [self addLikedRestaurantToUser:self.restaurantToAddToLikesFollowingLoginSignup];
}

@end


