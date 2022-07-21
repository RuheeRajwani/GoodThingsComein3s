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
-(void)getRestaurantSearchResults:(NSString *)location searchTerm:(NSString *)searchTerm completion:(void(^)(NSArray *restaurants, NSError *error))completion;
- (instancetype) initWithAPIKey:(NSString *)APIKey;

@end

NS_ASSUME_NONNULL_END
