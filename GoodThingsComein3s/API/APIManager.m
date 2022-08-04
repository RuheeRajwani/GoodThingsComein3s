//
//  APIManager.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/12/22.
//
#import "APIManager.h"
#import "Restaurant.h"

static NSString * const yelpBuisnessSearchString = @"https://api.yelp.com/v3/businesses/search";
static NSString * const yelpBuisnessDetailsString = @"https://api.yelp.com/v3/businesses/";

@interface APIManager()

@property (nonatomic) NSString *authHeader;
@property (nonatomic) NSArray *filterPriority;
@property (nonatomic) NSArray *priceFilters;
@property (nonatomic) NSArray *ratingFilters;

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Config" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"YELP_API_KEY"];
    self.authHeader = [NSString stringWithFormat:@"Bearer %@", key];
    return self;
}

- (NSMutableURLRequest*)_getURLRequestForURLString: (NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    return request;
}

#pragma mark - Requests

- (void)getGeneratedRestaurants:(NSString *)location prices:(NSArray *)priceFilters cuisines:(NSString *)cuisineFilters ratings:(NSArray *)ratingFilters radius:(NSNumber *)radius filterPriority:(NSArray *)filterPriority completion:(void(^)(NSArray *restaurants, NSError *error))completion {
    
    self.filterPriority = filterPriority;
    self.priceFilters = priceFilters;
    self.ratingFilters = ratingFilters;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%i", yelpBuisnessSearchString,@"?location=",location,@"&limit=", 50];
    
    if (radius != 0){
        urlString = [NSString stringWithFormat:@"%@%@%@%@%i%@%i", yelpBuisnessSearchString,@"?location=",location, @"&radius=", radius.intValue,@"&limit=", 50];
    }
    
    if (cuisineFilters != nil){
        urlString = [NSString stringWithFormat:@"%@%@%@", urlString, @"&categories=", cuisineFilters];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@", urlString, @"&categories=restaurants"];
    }
    
    NSMutableURLRequest *request =  [self _getURLRequestForURLString:urlString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@",error.description);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *restaurantDictionaries= dataDictionary[@"businesses"];
               NSArray *restaurants = [Restaurant restaurantsWithArray:restaurantDictionaries];
               
               completion([self filterRestaurants:restaurants],nil);
           }
    }];
    [task resume];
}

- (NSArray*)filterRestaurants: (NSArray*)restaurantsToFilter {
    if (self.filterPriority.count != 0){
        for(Restaurant *restaurant in restaurantsToFilter){
            restaurant.score = [self calculateRestaurantScore:restaurant];
        }
        restaurantsToFilter = [restaurantsToFilter sortedArrayUsingComparator:^NSComparisonResult(Restaurant *restaurant1, Restaurant *restaurant2) {
            if (restaurant1.score.intValue < restaurant2.score.intValue) {
                return NSOrderedDescending;
            } else if (restaurant1.score.intValue > restaurant2.score.intValue) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
    }
    return restaurantsToFilter;
}

- (NSNumber*)calculateRestaurantScore: (Restaurant *)restaurant{
    int scalingFactor = 6;
    int score = 0;
    for (NSString *filter in self.filterPriority){
        if([filter isEqualToString:@"price"]){
            int priceScore = 0;
            for(NSNumber *priceFilter in self.priceFilters){
                if([priceFilter intValue] == [restaurant.priceValue intValue]){
                    priceScore= 10*scalingFactor;
                    break;
                } else if ([priceFilter intValue] >  [restaurant.priceValue intValue]){
                    priceScore = 5*scalingFactor;
                }
            }
            score += priceScore;
        } else if ([filter isEqualToString:@"rating"]){
            int ratingScore =0;
            for (NSNumber *ratingFilter in self.ratingFilters){
                if([ratingFilter intValue] == [restaurant.ratingValue intValue]){
                    ratingScore = 10*scalingFactor;
                    break;
                } else if ([ratingFilter intValue] < [restaurant.ratingValue intValue]){
                    ratingScore = 8*scalingFactor;
                }
            }
            score += ratingScore;
        }
    }
    return [NSNumber numberWithInt:score];
}

- (void)getRestaurantSearchResults:(NSString *)location searchTerm:(NSString *)searchTerm completion:(void(^)(NSArray *restaurants, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@", yelpBuisnessSearchString,@"?location=",location, @"&term=", searchTerm];
    
    NSMutableURLRequest *request =  [self _getURLRequestForURLString:urlString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@",error.description);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *restaurantDictionaries= dataDictionary[@"businesses"];
               NSArray *restaurants = [Restaurant restaurantsWithArray:restaurantDictionaries];
               completion(restaurants,nil);
           }
    }];
    [task resume];
}

- (void)getRestaurantDetails:(NSString *)restaurantID completion:(void(^)(NSDictionary *restaurant, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", yelpBuisnessDetailsString, restaurantID];
    
    NSMutableURLRequest *request =  [self _getURLRequestForURLString:urlString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@",error.description);
           }
           else {
               NSDictionary *restaurantDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               completion(restaurantDictionary,nil);
           }
    }];
    [task resume];
}

- (void)getRestaurantReviews:(NSString *)restaurantID completion:(void(^)(NSArray *reviews, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", yelpBuisnessDetailsString, restaurantID,@"/reviews"];
    
    NSMutableURLRequest *request =  [self _getURLRequestForURLString:urlString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@",error.description);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *reviews= dataDictionary[@"reviews"];
               completion(reviews,nil);
           }
    }];
    [task resume];
}

@end
