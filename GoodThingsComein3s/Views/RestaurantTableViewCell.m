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

- (instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]){
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTapGesture];
    }
    return self;
}

-(void) didDoubleTap: (UITapGestureRecognizer *)recognizer {
    [self.delegate didTapLikeForRestaurant:self.restaurant];
}

- (IBAction)homeViewControllerDidTapLike:(id)sender {
    [self.delegate didTapLikeForRestaurant:self.restaurant];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
}

- (void)setRestaurant:(Restaurant *)restaurant {
    if (restaurant !=nil) {
        _restaurant = restaurant;
        
        self.restaurantNameLabel.text = self.restaurant.name;
        self.restaurantAddressLabel.text = self.restaurant.displayAddress;
        self.restaurantCategoriesLabel.text = self.restaurant.categoriesDisplayString;
        self.restaurantPriceLabel.text = self.restaurant.price;
        self.restaurantImageView.image = self.restaurant.restaurantImage;
        self.ratingImageView.image = self.restaurant.ratingImage;
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        
        if ([PFUser currentUser] != nil) {
            for (PFObject *likedRestaurant in [PFUser currentUser][@"likedRestaurants"]) {
                [likedRestaurant fetchIfNeeded];
                if ([likedRestaurant[@"restaurantYelpID"] isEqualToString:self.restaurant.restaurantYelpID]) {
                    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

@end
