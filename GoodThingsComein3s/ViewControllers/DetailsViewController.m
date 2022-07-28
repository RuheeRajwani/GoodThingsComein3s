//
//  DetailsViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/28/22.
//

#import "DetailsViewController.h"
#import "APIManager.h"
#import "AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *restaurantPhotosCollectionVIew;
@property (nonatomic) NSDictionary *restaurantToShow;

@end

@implementation DetailsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [[APIManager shared] getRestaurantDetails:self.yelpRestaurantID completion:^(NSDictionary * _Nonnull restaurant, NSError * _Nonnull error) {
        if(error == nil){
        self.restaurantToShow = restaurant;
        [self setView];
        }
    }];
}

-(void) setView {
    self.restaurantNameLabel.text = self.restaurantToShow[@"name"];
}


@end
