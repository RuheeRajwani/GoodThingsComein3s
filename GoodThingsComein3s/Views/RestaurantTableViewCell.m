//
//  RestaurantTableViewCell.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/18/22.
//

#import "RestaurantTableViewCell.h"
#import "UIImageView+AFNetworking.h"


@implementation RestaurantTableViewCell

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
