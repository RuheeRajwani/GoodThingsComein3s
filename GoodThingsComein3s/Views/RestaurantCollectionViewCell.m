//
//  RestaurantCollectionViewCell.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/21/22.
//

#import "RestaurantCollectionViewCell.h"
#import <Parse/Parse.h>

@implementation RestaurantCollectionViewCell

-(void) setRestaurant:(PFObject *)restaurant {
    _restaurant = restaurant;
    [self.restaurant fetchIfNeeded];
    if (restaurant != nil) {
        self.restaurantName.text = self.restaurant[@"name"];
        [self.restaurant[@"image"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                self.restaurantImage.image = image;
            }
        }];
        
    }
}

@end
