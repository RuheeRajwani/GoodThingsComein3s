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
    
    self.rating = buisness[@"rating"];
    self.name = buisness[@"name"];
    self.price = buisness[@"price"];
    self.categories = buisness[@"categories"];
    self.displayAddress = buisness[@"location"][@"display_address"];
    self.imageURL = buisness[@"image_url"];
    
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
