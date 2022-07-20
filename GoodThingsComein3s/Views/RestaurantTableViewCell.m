//
//  RestaurantTableViewCell.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/18/22.
//

#import "RestaurantTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>


@implementation RestaurantTableViewCell
- (IBAction)homeViewControllerDidTapLike:(id)sender {
    PFUser *curr = [PFUser currentUser];
    if(curr != nil){
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        
        [curr[@"likedRestaurants"] addObject: self.restaurant.restaurantID];
        [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
          if (succeeded) {
              NSLog(@"Successfully added");
              NSLog(@"%@", curr[@"likedRestaurants"][0]);
          } else {
              NSLog(@"Error liking restaurant");
              
          }
        }];
    }else{

    }
    
}

-(void) setRestaurant:(Restaurant *)restaurant{
    if(restaurant !=nil){
        _restaurant = restaurant;
        
        self.restaurantNameLabel.text = self.restaurant.name;
        self.restaurantAddressLabel.text = self.restaurant.displayAddress;
        self.restaurantCategoriesLabel.text = self.restaurant.categories;
        self.restaurantPriceLabel.text = self.restaurant.price;
        self.restaurantImageView.image = self.restaurant.restaurantImage;
        self.ratingImageView.image = self.restaurant.ratingImage;
    }
    
    
}

@end
