//
//  RestaurantCollectionViewCell.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/21/22.
//

#import "RestaurantCollectionViewCell.h"
#import <Parse/Parse.h>
#import "Restaurant.h"

@implementation RestaurantCollectionViewCell

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    if (restaurant != nil) {
        self.restaurantName.text = self.restaurant.name;
        self.restaurantImage.image = self.restaurant.restaurantImage;
    }
}

@end
