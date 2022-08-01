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

@interface ProfileViewController ()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameFieldToFill;
@property (weak, nonatomic) IBOutlet UICollectionView *profileLikedRestaurantsCollectionView;
@property (nonatomic) NSMutableArray *likedRestaurants;

@end

@implementation ProfileViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self getUserInformation];
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
        PFObject *restaurantToView = self.likedRestaurants[restaurantIndexPath.row];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.yelpRestaurantID = restaurantToView[@"yelpID"];
        
    }
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RestaurantCollectionViewCell" forIndexPath:indexPath];
    cell.restaurant = self.likedRestaurants[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.likedRestaurants.count;
}


-(void) getUserInformation {
    PFUser *curr = [PFUser currentUser];
    if(curr != nil) {
        NSString *greeting =@"Hi ";
        NSString *exclaimation = @"!";
        self.nameFieldToFill.text =[NSString stringWithFormat:@"%@%@%@", greeting, [PFUser currentUser].username, exclaimation];
        self.likedRestaurants = [PFUser currentUser][@"likedRestaurants"];
        [self.profileLikedRestaurantsCollectionView reloadData];
       
    } else {
        [self performSegueWithIdentifier:@"profileToSignUpLogin" sender:@"profileView"];
    }
}

@end
