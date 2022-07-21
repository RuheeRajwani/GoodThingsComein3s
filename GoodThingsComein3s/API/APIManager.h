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

- (void)getGeneratedRestaurants:(NSString *)location price:(NSString *)price categories:(NSString *)categories radius:(NSInteger)radius  completion:(void(^)(NSArray *restaurants, NSError *error))completion;
- (void)getRestaurantByID:(NSString *)location restaurantID:(NSString *)restaurantID completion:(void(^)(NSObject *restaurant, NSError *error))completion;
- (instancetype) initWithAPIKey:(NSString *)APIKey;

@end

NS_ASSUME_NONNULL_END
