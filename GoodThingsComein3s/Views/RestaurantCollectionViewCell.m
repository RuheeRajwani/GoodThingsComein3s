//
//  RestaurantCollectionViewCell.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/21/22.
//

#import "RestaurantCollectionViewCell.h"

@implementation RestaurantCollectionViewCell

-(void) setRestaurant:(NSDictionary *)dictionary{
    if(dictionary !=nil){
        _dictionary = dictionary;
        
        self.restaurantName.text = self.dictionary[@"name"];
        
        NSURL *restaurantImageURL = [NSURL URLWithString: dictionary[@"image_url"]];
        NSData *restaurantImageData = [NSData dataWithContentsOfURL:restaurantImageURL];
        self.restaurantImage.image = [UIImage imageWithData:restaurantImageData];
    }
}

@end
