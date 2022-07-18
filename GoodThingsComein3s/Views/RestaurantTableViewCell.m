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
        if(self.restaurant.categories.count > 0){
            NSString *categoryLabelText = [[NSString alloc] init];
            for(NSDictionary *category in self.restaurant.categories){
                if([categoryLabelText isEqualToString:@""]){
                    categoryLabelText = category[@"title"];
                } else {
                    categoryLabelText = [NSString stringWithFormat:@"%@%@%@", categoryLabelText,@", " ,category[@"title"] ];
                }
            }
            self.restaurantCategoriesLabel.text = categoryLabelText;
        }
        
        NSString *locationLabelText = [[NSString alloc] init];
        for(NSString *partOfLocation in self.restaurant.displayAddress){
            if([locationLabelText isEqualToString:@""]){
                locationLabelText = partOfLocation;
            } else {
                locationLabelText = [NSString stringWithFormat:@"%@%@%@", locationLabelText,@", " ,partOfLocation];
            }
        }
        self.restaurantAddressLabel.text = locationLabelText;
        
        int rating = (int) (self.restaurant.rating.doubleValue +.5);
        
        if(rating == 1){
            self.ratingImageView.image = [UIImage imageNamed:@"1Star"];
            
        } else if (rating == 2){
            self.ratingImageView.image = [UIImage imageNamed:@"2Stars"];
            
        } else if (rating == 3){
            self.ratingImageView.image = [UIImage imageNamed:@"3Stars"];
            
        }else if (rating == 4){
            self.ratingImageView.image = [UIImage imageNamed:@"4Stars"];
            
        }else if(rating == 5){
            self.ratingImageView.image = [UIImage imageNamed:@"5Stars"];
            
        }
        
        [self.restaurantImageView setImageWithURL:[NSURL URLWithString:self.restaurant.imageURL]];
    }
    
    
}

@end
