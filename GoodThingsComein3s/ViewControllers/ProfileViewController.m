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

@interface ProfileViewController ()<SignUpLoginViewControllerDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameFieldToFill;
@property (weak, nonatomic) IBOutlet UICollectionView *profileLikedRestaurantsCollectionView;
@property (nonatomic) NSMutableArray *likedRestaurants;

@end

@implementation ProfileViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self getUserInformation];
}

- (void)getUserInformation {
    PFUser *curr = [PFUser currentUser];
    if(curr != nil) {
        NSString *greeting =@"Hi ";
        NSString *exclaimation = @"!";
        self.nameFieldToFill.text =[NSString stringWithFormat:@"%@%@%@", greeting, [PFUser currentUser].username, exclaimation];
        self.likedRestaurants = [PFUser currentUser][@"likedRestaurants"];
        [self.profileLikedRestaurantsCollectionView reloadData];
       
    } else {
        [self performSegueWithIdentifier:@"profilePageToSignUpLoginSegue" sender:@"profileView"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileLikedRestaurantsCollectionView.dataSource = self;
    self.likedRestaurants = [[NSMutableArray alloc]init];
    
    [self getUserInformation];
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
        [self getUserInformation];
    }
    

    
   
    
    @end
