//
//  ProfileViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "TabBarViewController.h"
#import "RestaurantCollectionViewCell.h"
#import "APIManager.h"
#import "AFNetworking.h"
#import "DetailsViewController.h"
#import "Restaurant.h"
#import "SignUpLoginViewController.h"
#import "DGActivityIndicatorView.h"

@interface ProfileViewController ()<SignUpLoginViewControllerDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameFieldToFill;
@property (weak, nonatomic) IBOutlet UICollectionView *profileLikedRestaurantsCollectionView;
@property (nonatomic) NSMutableArray *likedRestaurants;
@property (weak, nonatomic) IBOutlet UILabel *yourSavedRestaurantsLabel;
@property (nonatomic) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation ProfileViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self _getUserInformation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileLikedRestaurantsCollectionView.dataSource = self;
    self.likedRestaurants = [[NSMutableArray alloc]init];
    
    self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulseSync tintColor:[UIColor colorWithRed:45/255.0 green:121/255.0 blue:253/255.0 alpha:1.0] size:50.0f];
    self.activityIndicatorView.frame = CGRectMake(self.view.center.x - 25, self.view.center.y - 25, 50.0f, 50.0f);
    [self.view addSubview:self.activityIndicatorView];
     
    [self _getUserInformation];
}

- (IBAction)profileViewControllerDidTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        mySceneDelegate.window.rootViewController = tabBarVC;
        
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"likedRestaurantToDetailsView"]) {
        NSIndexPath *restaurantIndexPath = [self.profileLikedRestaurantsCollectionView indexPathForCell:sender];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.restaurantToShow = [self _pfObjectToRestaurant: self.likedRestaurants[restaurantIndexPath.row]];
    }
    if ([[segue identifier] isEqualToString:@"profilePageToSignUpLoginSegue"]) {
        SignUpLoginViewController *signUpLoginVC = [segue destinationViewController];
        signUpLoginVC.delegate = self;
    }
    
}

#pragma mark - Helper Methods

- (Restaurant *) _pfObjectToRestaurant:(PFObject *)likedRestaurant{
    Restaurant *restaurantToReturn = [[Restaurant alloc]init];
    [likedRestaurant fetchIfNeeded];
    restaurantToReturn.name = likedRestaurant[@"name"];
    restaurantToReturn.displayAddress = likedRestaurant[@"displayAddress"];
    restaurantToReturn.priceDisplayString = likedRestaurant[@"priceDisplayString"];
    restaurantToReturn.categoriesDisplayString = likedRestaurant[@"categoriesDisplayString"];
    restaurantToReturn.restaurantYelpID = likedRestaurant[@"restaurantYelpID"];
    
    PFFileObject *restaurantImageFile = likedRestaurant[@"restaurantImage"];
    NSData *restaurantImageData = restaurantImageFile.getData;
    restaurantToReturn.restaurantImage = [UIImage imageWithData:restaurantImageData];
    
    PFFileObject *ratingImageFile = likedRestaurant[@"ratingImage"];
    NSData *ratingImageData = ratingImageFile.getData;
    restaurantToReturn.ratingImage = [UIImage imageWithData:ratingImageData];
    
    return restaurantToReturn;
}

- (void)_getUserInformation {
    [self.activityIndicatorView startAnimating];
    [self.activityIndicatorView setHidden:NO];
    
    [self.nameFieldToFill setHidden:YES];
    [self.yourSavedRestaurantsLabel setHidden:YES];
    
    PFUser *curr = [PFUser currentUser];
    if(curr != nil) {
        NSString *greeting =@"Hi ";
        NSString *exclaimation = @"!";
        self.nameFieldToFill.text =[NSString stringWithFormat:@"%@%@%@", greeting, [PFUser currentUser].username, exclaimation];
        self.likedRestaurants = [PFUser currentUser][@"likedRestaurants"];
        [self.profileLikedRestaurantsCollectionView reloadData];
        
        [self.nameFieldToFill setHidden:NO];
        [self.yourSavedRestaurantsLabel setHidden:NO];
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidden:YES];
       
    } else {
        [self performSegueWithIdentifier:@"profilePageToSignUpLoginSegue" sender:@"profileView"];
    }
    
}

#pragma mark - Collection View

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RestaurantCollectionViewCell" forIndexPath:indexPath];
    cell.restaurant = [self _pfObjectToRestaurant:self.likedRestaurants[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.likedRestaurants.count;
}

- (void)signUpLoginViewControllerDidDismissForUser {
        [self _getUserInformation];
}
    
@end
