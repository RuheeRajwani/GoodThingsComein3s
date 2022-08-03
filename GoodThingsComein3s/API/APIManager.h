//
//  APIManager.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/12/22.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : AFHTTPSessionManager

+(instancetype) shared;

- (void)getGeneratedRestaurants:(NSString *)location prices:(NSArray *)priceFilters cuisines:(NSArray *)cuisineFilters ratings:(NSArray *)ratingFilters radius:(NSNumber *)radius filterPriority:(NSArray *)filterPriority completion:(void(^)(NSArray *restaurants, NSError *error))completion;
- (void)getRestaurantSearchResults:(NSString *)location searchTerm:(NSString *)searchTerm completion:(void(^)(NSArray *restaurants, NSError *error))completion;
- (void)getRestaurantDetails:(NSString *)restaurantID completion:(void(^)(NSDictionary *restaurant, NSError *error))completion;
- (void)getRestaurantReviews:(NSString *)restaurantID completion:(void(^)(NSArray *reviews, NSError *error))completion;
- (instancetype) init;

@end

NS_ASSUME_NONNULL_END
