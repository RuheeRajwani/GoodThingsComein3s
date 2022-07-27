//
//  APIManager.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/12/22.
//

#import "APIManager.h"
#import "Restaurant.h"

static NSString * const yelpBuisnessSearchString = @"https://api.yelp.com/v3/businesses/search";
@interface APIManager()

@property (nonatomic) NSString *authHeader;

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
- (instancetype)init{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Config" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"YELP_API_KEY"];
    self.authHeader = [NSString stringWithFormat:@"Bearer %@", key];
    return self;
}


- (void)getGeneratedRestaurants:(NSString *)location price:(NSString *)price categories:(NSString *)categories radius:(NSInteger)radius completion:(void(^)(NSArray *restaurants, NSError *error))completion{
    NSString *urlString = yelpBuisnessSearchString;
    
    //adding parameters to url
    if(location==nil){
        location = @"Seattle";
    }
    urlString = [NSString stringWithFormat:@"%@%@%@",urlString, @"?location=", location];
    if(price!=nil){
        urlString = [NSString stringWithFormat:@"%@%@%@",urlString, @"&price=", price];
    }
    if(categories!=nil){
        urlString = [NSString stringWithFormat:@"%@%@%@",urlString, @"&categories=", price];
    }
    
    NSArray *requestAndSession =  [self setRequestAndSession:urlString];
    NSURLSessionDataTask *task = [requestAndSession[1] dataTaskWithRequest:requestAndSession[0] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {           if (error != nil) {
               NSLog(@"%@",error.description);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);
               NSArray *restaurantDictionaries= dataDictionary[@"businesses"];
               NSMutableArray *restaurants = [Restaurant restaurantsWithArray:restaurantDictionaries];
               completion(restaurants,nil);
              
               
           }
    }];
    [task resume];
}

-(void)getRestaurantSearchResults:(NSString *)location searchTerm:(NSString *)searchTerm completion:(void(^)(NSArray *restaurants, NSError *error))completion{
    NSString *urlString = yelpBuisnessSearchString;
    urlString = [NSString stringWithFormat:@"%@%@%@",urlString, @"?location=", location];
    urlString = [NSString stringWithFormat:@"%@%@%@",urlString, @"&term=", searchTerm];
    
    NSArray *requestAndSession =  [self setRequestAndSession:urlString];
    NSURLSessionDataTask *task = [requestAndSession[1] dataTaskWithRequest:requestAndSession[0] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@",error.description);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);
               NSArray *restaurantDictionaries= dataDictionary[@"businesses"];
               NSMutableArray *restaurants = [Restaurant restaurantsWithArray:restaurantDictionaries];
               completion(restaurants,nil);
              
               
           }
    }];
    [task resume];
    
}

-(NSArray*) setRequestAndSession: (NSString *)urlString{
    
    NSMutableArray *toReturn = [[NSMutableArray alloc] init];

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    [request setValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    [toReturn addObject:request];
    [toReturn addObject:session];
    
    return toReturn;
}



@end
