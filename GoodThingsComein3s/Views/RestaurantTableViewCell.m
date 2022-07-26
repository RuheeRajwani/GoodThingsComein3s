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
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    if(curr != nil){
        NSMutableArray *likedRestaurants =  curr[@"likedRestaurants"];
        [likedRestaurants addObject: [self restaurantToParseObject]];
        curr[@"likedRestaurants"]=likedRestaurants;
        [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
          if (succeeded) {
              NSLog(@"Successfully added");
              NSLog(@"%@", curr[@"likedRestaurants"]);
          } else {
              NSLog(@"Error liking restaurant");
              
          }
        }];
    }else{
        [self.delegate userLoginSignUp];
        
        
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
        
        if([PFUser currentUser] != nil){
            for( PFObject *likedRestaurant in [PFUser currentUser][@"likedRestaurants"]){
                [likedRestaurant fetchIfNeeded];
                if([likedRestaurant[@"yelpID"] isEqualToString:self.restaurant.restaurantID]){
                    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                }
            }
        }
        
        
    }
    
    
}

- (PFObject *)restaurantToParseObject {
    PFObject *restaurantToAdd = [[PFObject alloc] initWithClassName:@"Restaurant"];
    restaurantToAdd[@"name"] = self.restaurant.name;
    restaurantToAdd[@"yelpID"] = self.restaurant.restaurantID;
    NSData *imageData = UIImagePNGRepresentation(self.restaurant.restaurantImage);
    NSString *imageName = [NSString stringWithFormat:@"%@%@",self.restaurant.restaurantID, @"image"];
    restaurantToAdd[@"image"] = [PFFileObject fileObjectWithName:imageName data:imageData];
    return restaurantToAdd;
   
}
@end
