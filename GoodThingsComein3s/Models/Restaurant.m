//
//  Restaurant.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/18/22.
//

#import "Restaurant.h"

@implementation Restaurant

- (instancetype)initWithDictionary:(NSDictionary *)buisness {
    self = [super init];
    
    self.name = buisness[@"name"];
    self.price = buisness[@"price"];
    self.restaurantID = buisness[@"id"];
    
    NSURL *restaurantImageURL = [NSURL URLWithString: buisness[@"image_url"]];
    NSData *restaurantImageData = [NSData dataWithContentsOfURL:restaurantImageURL];
    self.restaurantImage = [UIImage imageWithData:restaurantImageData];
    
    if (buisness[@"categories"] != nil) {
        NSString *categoryLabelText = [[NSString alloc] init];
        for (NSDictionary *category in buisness[@"categories"]) {
            if ([categoryLabelText isEqualToString:@""]) {
                categoryLabelText = category[@"title"];
            } else {
                categoryLabelText = [NSString stringWithFormat:@"%@%@%@", categoryLabelText,@", " ,category[@"title"] ];
            }
        }
        self.categories = categoryLabelText;
    }
    
    NSString *locationLabelText = [[NSString alloc] init];
    for(NSString *partOfLocation in buisness[@"location"][@"display_address"]) {
        if([locationLabelText isEqualToString:@""]) {
            locationLabelText = partOfLocation;
        } else {
            locationLabelText = [NSString stringWithFormat:@"%@%@%@", locationLabelText,@", " ,partOfLocation];
        }
    }
    self.displayAddress = locationLabelText;
    
    NSNumber *rating = buisness[@"rating"];
    int ratingValue = (int)(rating.doubleValue +.5);
    
    if (ratingValue == 1) {
        self.ratingImage = [UIImage imageNamed:@"1StarWhiteBackground"];
        
    } else if (ratingValue == 2) {
        self.ratingImage = [UIImage imageNamed:@"2StarsWhiteBackground"];
        
    } else if (ratingValue == 3) {
        self.ratingImage = [UIImage imageNamed:@"3StarsWhiteBackground"];
        
    }else if (ratingValue == 4) {
        self.ratingImage = [UIImage imageNamed:@"4StarsWhiteBackground"];
        
    }else if(ratingValue == 5) {
        self.ratingImage = [UIImage imageNamed:@"5StarsWhiteBackground"];
    }
    return self;
}

+ (NSMutableArray *)restaurantsWithArray:(NSArray *)dictionaries {
    NSMutableArray *restaurants = [NSMutableArray array];
    for (NSDictionary *restaurantToAdd in dictionaries) {
        Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:restaurantToAdd];
        [restaurants addObject:restaurant];
    }
    return restaurants;
}

@end
