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
@property (nonatomic) NSMutableArray *restaurantArray;

@property (nonatomic) NSArray *priceFilters;
@property (nonatomic) NSArray *cuisineFilters;
@property (nonatomic) NSString *cuisineFilterParamRequestString;
@property (nonatomic) NSArray *ratingFilters;
@property (nonatomic) NSNumber *radius;
@property (nonatomic) NSMutableArray *filterPriority;

@property (nonatomic)Boolean didFiltersChange;

@property (weak, nonatomic) IBOutlet UIButton *priceFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *cuisineFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *distanceFilterButton;
@property (weak, nonatomic) IBOutlet UILabel *noRemainingRestaurantsLabel;



@property (nonatomic) UIRefreshControl *refreshControl;
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
    self.filterPriority = [[NSMutableArray alloc] init];
    
    self.didFiltersChange = YES;
}

- (void)fetchRestaurants {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    NSString *location = @"Seattle";
    if ([PFUser currentUser] != nil){
        [[PFUser currentUser] fetchIfNeeded];
        location = [PFUser currentUser][@"location"];
    }
    
    NSNumber *milesToMeters = [NSNumber numberWithInt:(int) [self.radius intValue] * 1609.34];
    
    if(self.didFiltersChange) {
        self.didFiltersChange = NO;
        [[APIManager shared] getGeneratedRestaurants:location prices:self.priceFilters cuisines:self.cuisineFilterParamRequestString ratings:self.ratingFilters radius:milesToMeters filterPriority:[self.filterPriority copy] completion:^(NSArray * _Nonnull restaurants, NSError * _Nonnull error) {
            if(restaurants) {
                self.restaurantArray = [restaurants mutableCopy];
                NSLog(@"Successfully loaded array");
                [self.homeRestaurantTableView reloadData];
                [self _refreshHomeScreen];
            } else {
                NSLog(@"Error loading restaurants");
            }
        }];
    } else {
        if (self.restaurantArray.count<3){
            [self.noRemainingRestaurantsLabel setHidden:NO];
            [self.refreshControl endRefreshing];
            [self.activityIndicator setHidden:YES];
            
        } else {
            [self _refreshHomeScreen];
        }
    }
}

- (void) _refreshHomeScreen {
    [self.noRemainingRestaurantsLabel setHidden:YES];
    [self.homeRestaurantTableView reloadData];
    [self.refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
    self.homeRestaurantTableView.hidden = NO;
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
    if(indexPath.row == 2){
        for (int i=0; i<3; i++){
            [self.restaurantArray removeObjectAtIndex:0];
        }
    }
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - Delegates

- (Boolean)_didRatingPriceFilterChange:(NSArray *)array1 array2:(NSArray *)array2{
    if(array1.count==array2.count){
        for( int i=0; i<array1.count;i++){
            NSNumber *array1Val = array1[i];
            NSNumber *array2Val = array2[i];
            if(array1Val.intValue != array2Val.intValue){
                return YES;
            }
        }
    } else {
        return YES;
    }
    return NO;
}

- (Boolean)_didCuisineFilterChange:(NSArray *)array1 array2:(NSArray *)array2{
    if (array1 != nil && array2 !=nil){
        if(array1.count == array2.count){
            for( int i=0; i<array1.count;i++){
                NSString *array1String = array1[i];
                NSString *array2String = array2[i];
                if(![array1String isEqualToString:array2String]){
                    return YES;
                }
            }
        } else {
            return YES;
        }
    } else if (array1 == nil && array2 == nil){
        return NO;
    } else {
        return YES;
    }
    return YES;
}

- (void)didApplyPriceFilters:(NSArray *)selectedFilters {
    self.didFiltersChange = [self _didRatingPriceFilterChange:selectedFilters array2:self.priceFilters];
    self.priceFilters = selectedFilters;
    if(self.priceFilters.count != 0){
        [self.priceFilterButton setSelected:YES];
        if (![self.filterPriority containsObject:@"price"]){
            [self.filterPriority addObject:@"price"];
        }
    }
}

- (void)didApplyRatingFilters:(nonnull NSArray *)selectedFilters {
    self.didFiltersChange = [self _didRatingPriceFilterChange:selectedFilters array2:self.ratingFilters];
    self.ratingFilters = selectedFilters;
    if(self.ratingFilters.count != 0){
        [self.ratingFilterButton setSelected:YES];
        if (![self.filterPriority containsObject:@"rating"]){
            [self.filterPriority addObject:@"rating"];
        }
    }
}

-(void) didApplyCuisineFilters:(NSArray *)selectedFilters categoriesParamRequestString:(NSString *)categoriesParamRequestString{
    self.cuisineFilterParamRequestString = categoriesParamRequestString;
    if(selectedFilters.count != 0){
        self.didFiltersChange = [self _didCuisineFilterChange:selectedFilters array2:self.cuisineFilters];
        [self.cuisineFilterButton setSelected:YES];
        if (![self.filterPriority containsObject:@"cuisine"]){
            [self.filterPriority addObject:@"cuisine"];
        }
    } else {
        [self.cuisineFilterButton setSelected:NO];
        if ([self.filterPriority containsObject:@"cuisine"]){
            [self.filterPriority removeObject:@"cuisine"];
        }
        self.didFiltersChange = [self _didCuisineFilterChange:selectedFilters array2:self.cuisineFilters];
    }
    self.cuisineFilters = selectedFilters;
}

- (void)didApplyDistanceFilter:(NSNumber *)selectedRadius {
    if(self.radius != nil){
        self.didFiltersChange = [selectedRadius isEqualToNumber:self.radius];
    } else {
        self.didFiltersChange = YES;
    }
    self.radius = selectedRadius;
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
    restaurantToAdd[@"priceDisplayString"] = restaurantToConvert.priceDisplayString;
    restaurantToAdd[@"displayAddress"] =  restaurantToConvert.displayAddress;
    restaurantToAdd[@"categoriesDisplayString"] = restaurantToConvert.categoriesDisplayString;
    
    
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


