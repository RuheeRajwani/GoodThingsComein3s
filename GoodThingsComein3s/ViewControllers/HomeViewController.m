//
//  HomeViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import "HomeViewController.h"
#import "PriceFilterViewController.h"
#import "APIManager.h"
#import "AFNetworking.h"
#import "RestaurantTableViewCell.h"
#import "SignUpLoginViewController.h"
#import "DetailsViewController.h"

@interface HomeViewController () <PriceFilterViewControllerDelegate, RestaurantTableViewCellDelegate, SignUpLoginViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *homeRestaurantTableView;
@property (nonatomic) NSArray *restaurantArray;
@property (nonatomic) NSArray *priceFilters;
@property (weak, nonatomic) IBOutlet UIButton *priceFilterButton;
@property (nonatomic) NSString *categories;
@property (nonatomic) NSInteger *radius;
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
}

- (void)fetchRestaurants {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"HomeToPriceFilterSegue"]) {
        PriceFilterViewController *priceFilterVC = [segue destinationViewController];
        priceFilterVC.previouslySelectedPriceFilters = self.priceFilters;
        priceFilterVC.delegate= self;
    }
    if ([[segue identifier] isEqualToString:@"LiketoSignUpLoginSegue"]) {
        SignUpLoginViewController *signUpLoginVC = [segue destinationViewController];
        signUpLoginVC.delegate= self;
    }
    if ([[segue identifier] isEqualToString:@"RestaurantTableViewCellToRestaurantDetailsView"]) {
        NSIndexPath *restaurantIndexPath = [self.homeRestaurantTableView indexPathForCell:sender];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.restaurantToShow = self.restaurantArray[restaurantIndexPath.row];
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


